import math
import numpy as np

class OutOfRange(Exception):
    pass
class OutOfRangeRx(OutOfRange):
    pass
class OutOfRangeRy(OutOfRange):
    pass
class OutOfRangeRz(OutOfRange):
    pass
class OutOfRangeRxMax(OutOfRangeRx):
    pass
class OutOfRangeRxMin(OutOfRangeRx):
    pass
class OutOfRangeRyMax(OutOfRangeRy):
    pass
class OutOfRangeRyMin(OutOfRangeRy):
    pass
class OutOfRangeRzMax(OutOfRangeRz):
    pass
class OutOfRangeRzMin(OutOfRangeRz):
    pass
class IrregularFieldMap(Exception):
    pass

class FieldMap:
    
    def __init__(self, fname, 
                 polyfit_exponents = None,
                 analysis_missing_field = False,
                 threshold_field_fraction = 0.5):
        
        self.filename = None
        self.fieldmap_label = None
         
        self.rx,       self.ry,       self.rz        = None, None, None # unique and sorted 1D numpy arrays with values of corresponding coordinates
        self.rx_nrpts, self.ry_nrpts, self.rz_nrpts  = None, None, None # number of distinct values of each coordinate in the fieldmap 
        self.rx_min,   self.ry_min,   self.rz_min    = None, None, None # minimum values of coordinates
        self.rx_max,   self.ry_max,   self.rz_max    = None, None, None # maximum values of coordinates
        self.rx_step,  self.step,     self.rz_step   = None, None, None # spacing between consecutive coordinate values
        
        # bx, by and bz field components of the fieldmap
        # ----------------------------------------------
        # these are 3D fieldmaps stored as lists whose elements are 2D fieldmaps.
        # (one for each y plane. usually only one at the midplane y = 0)
        # 2D fieldmaps are two dimensional numpy arrays: the first index (row) runs through different x values
        # wheres the second index (column) runs through differency longitudinal z coordinate
        # 
        # Ex:    If there is only the midplave 2D fieldmap, then
        #
        #        by_on_axis = self.by[0][self.rx_zero,:]
        #
        #        is a 1D numpy array containg the longitudinal vertical profile of the field at x == 0.
        #
        self.bx, self.by, self.bz = None, None, None
      
        # In order to estimate what field integrals are missing from the fielmap (outside its region) 
        # (1/z)^n, n>=2 polynomial interpolations are performed in the vicinities of both upstream and downstream 
        # limits of the fieldmap. The interpolated polynomial is used to extrapolate the asymptotic decaying of the
        # field and to thus obtain numerical estimates of the field integrals outside the fieldmap.
        # these estimates are stored in the lists below.
        #
        self.clear_extrapolation_coefficients()
        self.bx_missing_integral  = None  # list of estimated bx field line integrals outside the region of the field map
        self.by_missing_integral  = None  # list of estimated by field line integrals outside the region of the field map
        self.bz_missing_integral  = None  # list of estimated bz field line integrals outside the region of the field map
         
        # reads fieldmap from givem filename   
        self.read_fieldmap(fname)
        
        # does field extrapolation analysis 
        if analysis_missing_field:
            self.field_extrapolation_analysis(polyfit_exponents = polyfit_exponents, 
                                                threshold_field_fraction = threshold_field_fraction)

    def read_fieldmap(self, fname):

        with open(fname, 'r') as fp:
            content = fp.read()
        
        ''' finds index of data section start '''
        idx = content.find('Z[mm]')
        idx = content.find('\n', idx+1)
        idx = content.find('\n', idx+1)
            
        ''' data section '''
        raw_data = np.fromstring(content[idx+1:], dtype=float, sep=' ')
        data = raw_data.view()
        data.shape = (-1,6)
        # position data
        self.rx = np.unique(data[:,0])
        self.ry = np.unique(data[:,1])
        self.rz = np.unique(data[:,2])
        self.rx_min, self.rx_max, self.rx_nrpts = min(self.rx), max(self.rx), len(self.rx)
        self.ry_min, self.ry_max, self.ry_nrpts = min(self.ry), max(self.ry), len(self.ry)
        self.rz_min, self.rz_max, self.rz_nrpts = min(self.rz), max(self.rz), len(self.rz)
        if self.rx_nrpts * self.ry_nrpts * self.rz_nrpts != data.shape[0]:
            raise IrregularFieldMap('not a rectangular grid')
        self.rx_step = (self.rx_max - self.rx_min) / (self.rx_nrpts - 1.0) if self.rx_nrpts > 1 else 0.0            
        self.ry_step = (self.ry_max - self.ry_min) / (self.ry_nrpts - 1.0) if self.ry_nrpts > 1 else 0.0
        self.rz_step = (self.rz_max - self.rz_min) / (self.rz_nrpts - 1.0) if self.rz_nrpts > 1 else 0.0
        self.rx_zero = np.where(self.rx == 0)[0][0]
        self.ry_zero = np.where(self.ry == 0)[0][0]
        self.rz_zero = np.where(self.rz == 0)[0][0]
        
        # field data
        self.bx, self.by, self.bz = data[:,3].view(), data[:,4].view(), data[:,5].view()
        self.bx.shape, self.by.shape, self.bz.shape = (-1,self.rx_nrpts), (-1,self.rx_nrpts), (-1,self.rx_nrpts)
        self.bx = [np.transpose(self.bx)]
        self.by = [np.transpose(self.by)]
        self.bz = [np.transpose(self.bz)]
        
        
        ''' header section '''
        lines = content[:idx].split('\n')
        for line in lines:
            
            # empty line or comment
            if not line or (line[0] == '#'):
                continue
            words = line.split()
            if not words:
                continue
            
            cmd = words[0].lower()
            if cmd == 'nome_do_mapa:':
                self.fieldmap_label = ' '.join(words[1:])
                continue
            if cmd == 'data_hora:':
                self.timestamp = ' '.join(words[1:])
                continue
            if cmd == 'nome_do_arquivo:':
                self.filename = ' '.join(words[1:])
                continue
            if cmd == 'numero_de_imas:':
                self.nr_magnets = int(words[1])
                continue
            if cmd == 'nome_do_ima:':
                self.magnet_label = ' '.join(words[1:])
                continue
            if cmd == 'gap[mm]:':
                self.gap = float(words[1]) #[mm]
                continue
            if cmd == 'gap_controle[mm]:':
                try:
                    self.control_gap = float(words[1]) #[mm]
                except:
                    self.control_gap = None
                continue
            if cmd == 'comprimento[mm]:':
                self.length = float(words[1]) #[mm]
                continue
            if cmd == 'corrente[a]:':
                try:
                    self.current = float(words[1])#[A]
                except ValueError:
                    self.current = None
                continue
                 
    def __get_ix(self, rx):
        ix = int(math.floor((rx - self.rx_min) / self.rx_step)) if self.rx_nrpts > 1 else 0
        ix = ix-1 if ix == self.rx_nrpts-1 else ix
        return ix
    
    def __get_iy(self, ry):
        if self.ry_nrpts == 1:
            return 0
        iy = int(math.floor((ry - self.ry_min) / self.ry_step)) if self.ry_nrpts > 1 else 0
        iy = iy-1 if iy == self.ry_nrpts-1 else iy
        return iy
    
    def __get_iz(self, rz):
        iz = int(math.floor((rz - self.rz_min) / self.rz_step)) if self.rz_nrpts > 1 else 0
        iz = iz-1 if iz == self.rz_nrpts-1 else iz
        return iz
               
    def interpolate_set(self, points):
        
        field = np.zeros(points.shape)
        for i in range(points.shape[1]):
            field[:,i] = self.interpolate(*points[:,i])
        return field
    
    def interpolate(self, rx, ry, rz):

            
        def rz_interpolate(rz, ix, iy):
                
            def field_rz_extrapolate(rz, coeffs):
                try:
                    b = np.zeros(rz.shape)
                except AttributeError:
                    b = 0.0
                x = 1.0/rz
                for i in range(len(coeffs)):
                    b += coeffs[i] * (x ** self.__polyfit_exponents[i])
                    return b
                
            if rz > self.rz_max:
                if self._bx_pos_coeffs is None:
                    bx, by, bz = 0,0,0
                    #raise OutOfRangeRzMax('rz = {0:f} > rz_max = {1:f} [mm]'.format(rz, self.rz_max))
                else:
                    bx_pos_coeffs = self._bx_pos_coeffs[iy][ix]
                    by_pos_coeffs = self._by_pos_coeffs[iy][ix]
                    bz_pos_coeffs = self._bz_pos_coeffs[iy][ix]
                    bx = field_rz_extrapolate(rz, bx_pos_coeffs)
                    by = field_rz_extrapolate(rz, by_pos_coeffs)
                    bz = field_rz_extrapolate(rz, bz_pos_coeffs)
            elif rz < self.rz_min:
                if self._bx_neg_coeffs is None:
                    raise OutOfRangeRzMin('rz = {0:f} < rz_min = {1:f} [mm]'.format(rz, self.rz_min))
                bx_neg_coeffs = self._bx_neg_coeffs[iy][ix]
                by_neg_coeffs = self._by_neg_coeffs[iy][ix]
                bz_neg_coeffs = self._bz_neg_coeffs[iy][ix]
                bx = field_rz_extrapolate(rz, bx_neg_coeffs)
                by = field_rz_extrapolate(rz, by_neg_coeffs)
                bz = field_rz_extrapolate(rz, bz_neg_coeffs)
            else:

                iz = self.__get_iz(rz)
                iz1, iz2 = iz, iz+1 if self.rz_nrpts > 1 else iz
                fdz = (rz - self.rz[iz1])/self.rz_step if self.rz_step != 0.0 else 0.0
                
                b = self.bx[iy][ix,:]
                bx = b[iz1] + fdz * (b[iz2] - b[iz1])
                b = self.by[iy][ix,:]
                by = b[iz1] + fdz * (b[iz2] - b[iz1])
                b = self.bz[iy][ix,:]
                bz = b[iz1] + fdz * (b[iz2] - b[iz1])
                
            return (bx,by,bz)
        
        def interpolate_in_plane(bx,by,bz,ix,iy):
            
            ix1, ix2 = ix, ix+1 if self.rx_nrpts > 1 else ix
            
            # prev x
            bx_x1, by_x1, bz_x1 = rz_interpolate(rz = rz, ix = ix1, iy = iy)
            # next x
            bx_x2, by_x2, bz_x2 = rz_interpolate(rz = rz, ix = ix2, iy = iy)
            # interpolate in x
            fdx = (rx - self.rx[ix1])/self.rx_step if self.rx_step != 0.0 else 0.0
            bx = bx_x1 + fdx * (bx_x2 - bx_x1)
            by = by_x1 + fdx * (by_x2 - by_x1)
            bz = bz_x1 + fdx * (bz_x2 - bz_x1)
            
            return (bx, by, bz)
        
        brho = 10.00692271077752     # [T.m]
        btype = 'b2'
        if btype == 'b1':
            b_length = 828.08            # [mm]
            b_field  = - (2.766540/2.828549) * 0.583502298783241 # [T]
            ksi      = 3.0               # [mm]
            K        = -0.78 *1          # [1/m^2]
        elif btype == 'b2':
            b_length = 1228.262          # [mm]
            b_field  = - (4.103510/4.103511) * (4.103510/4.307675) * 0.583502298783241 # [T]
            ksi      = 3.0               # [mm]
            K        = -0.78 *1          # [1/m^2]
        elif btype == 'b3':
            b_length = 428.011            # [mm]
            b_field  =  - 0.583502298783241 # [T]
            ksi      = 3.0               # [mm]
            K        = -0.78 *1          # [1/m^2]
           
        # XRR
        Grad = (-K*brho)/1000            # [T/mm]  
        if rz < b_length/2.0 and rz > -b_length/2.0:
            f = 1.0 #1.0/(1.0 + math.exp((rz-b_length/2.0)/ksi))
        else:
            f = 0.0
            
        #f = 1.0/(1.0 + math.exp((rz-b_length/2.0)/ksi))
        g = Grad * rx         
        by = (b_field + g) * f
        return (0.0,by,0.0)
            
            
        # gets transverse coordinates indices into the regular rectangular grid
        
        try:        
            ix, iy, _ = self.pos2indices(rx, ry, rz, raise_exception_flag = True)
        except OutOfRangeRz:
            ix, iy, _ = self.pos2indices(rx, ry, rz, raise_exception_flag = False)
        
              
        # upper and lower fieldmaps
        bx_y1, bx_y2 = self.bx[iy], self.bx[iy+1] if self.ry_nrpts > 1 else self.bx[iy]
        by_y1, by_y2 = self.by[iy], self.by[iy+1] if self.ry_nrpts > 1 else self.by[iy]
        bz_y1, bz_y2 = self.bz[iy], self.bz[iy+1] if self.ry_nrpts > 1 else self.bz[iy]
        bx_y1, by_y1, bz_y1 = interpolate_in_plane(bx_y1, by_y1, bz_y1, ix, iy)
        bx_y2, by_y2, bz_y2 = interpolate_in_plane(bx_y2, by_y2, bz_y2, ix, iy)
        # interpolate in z
        fdy = (ry - self.ry[iy])/self.ry_step if self.ry_step != 0.0 else 0.0
        bx = bx_y1 + fdy * (bx_y2 - bx_y1)
        by = by_y1 + fdy * (by_y2 - by_y1)
        bz = bz_y1 + fdy * (bz_y2 - bz_y1)
            
        return (bx, by, bz)
          
    def integral_z(self, coeffs = None, field_line = None, rz_inf = -float('inf'), rz_sup = float('inf')):
        if coeffs is not None:
            integral = 0.0
            for i in range(len(coeffs)):
                n = self.__polyfit_exponents[i]
                integral += coeffs[i] * (rz_sup**(1-n) - rz_inf**(1-n)) / (1.0-n)
            return integral
        else:
            raise NotImplementedError
                
    def index2indices(self, i):
        raise NotImplementedError

    def pos2indices(self, rx,ry,rz, raise_exception_flag = True):
        
        if raise_exception_flag:
            if rx > self.rx_max:
                raise OutOfRangeRxMax('rx = {0:f} > rx_max = {1:f} [mm]'.format(rx, self.rx_max))
            if rx < self.rx_min:
                raise OutOfRangeRxMin('rx = {0:f} < rx_min = {1:f} [mm]'.format(rx, self.rx_min))
            if ry > self.ry_max:
                raise OutOfRangeRyMax('ry = {0:f} > ry_max = {1:f} [mm]'.format(ry, self.ry_max))
            if ry < self.ry_min:
                raise OutOfRangeRyMin('ry = {0:f} < ry_min = {1:f} [mm]'.format(ry, self.ry_min))
            if rz > self.rz_max:
                raise OutOfRangeRzMax('rz = {0:f} > rz_max = {1:f} [mm]'.format(rz, self.rz_max))
            if rz < self.rz_min:
                raise OutOfRangeRzMin('rz = {0:f} < rz_min = {1:f} [mm]'.format(rz, self.rz_min))
            
        iy = self.__get_iy(ry)
        ix = self.__get_ix(rx)
        iz = self.__get_iz(rz)
        return ix,iy,iz

    def clear_extrapolation_coefficients(self):
        self._bx_pos_coeffs, self._bx_neg_coeffs = None, None
        self._by_pos_coeffs, self._by_neg_coeffs = None, None
        self._bz_pos_coeffs, self._bz_neg_coeffs = None, None
        
    def field_extrapolation_analysis(self, threshold_field_fraction = 0.5, polyfit_exponents = None):
        
        if polyfit_exponents is None:
            self.__polyfit_exponents = [2,3,4,5,6,7,8,9,10,11,12,13,14,15]
        else:
            self.__polyfit_exponents = polyfit_exponents

        
        def calc_poly_coeffs(yplane_idx, fieldline_idx, field_component, threshold_field_fraction = threshold_field_fraction):
            
         
            field = field_component[yplane_idx]
            nr = len(self.__polyfit_exponents)
            
            '''rz > 0 extrapolation'''
            rz = self.rz[self.rz_zero+1:]
            field_line = field[fieldline_idx,self.rz_zero+1:]
            threshold_field = max(abs(field_line)) * threshold_field_fraction
            idx = np.where(abs(field_line) < threshold_field)[0]
            z = rz[idx]
            b = field_line[idx]
            x = 1.0/z
            vb = np.zeros((nr,1))
            vm = np.zeros((nr,nr))
            for idx_row in range(nr):
                n_row = self.__polyfit_exponents[idx_row]
                vb[idx_row,0] = np.dot(b, x**n_row)
                for idx_col in range(nr):
                    n_col = self.__polyfit_exponents[idx_col]
                    vm[idx_row, idx_col] = np.sum(x**(n_row+n_col))
            pos_coeffs = np.linalg.solve(vm, vb)[:,0]
            
            '''
            zl = np.linspace(z[0],20*z[-1],1000)
            bl = self.field_extrapole(pos_coeffs, zl)
            plt.plot(z,b)
            plt.plot(zl,bl)
            plt.show()
            binteg = self.field_integrate(coeffs = pos_coeffs, rz_inf = self.rz_max, rz_sup = float('inf'))
            '''
            
            '''rz < 0 extrapolation'''
            rz = self.rz[:self.rz_zero]
            field_line = field[fieldline_idx,:self.rz_zero]
            threshold_field = max(abs(field_line)) * threshold_field_fraction
            idx = np.where(abs(field_line) < threshold_field)[0]
            z = rz[idx]
            b = field_line[idx]
            x = 1.0/z
            vb = np.zeros((nr,1))
            vm = np.zeros((nr,nr))
            for idx_row in range(nr):
                n_row = self.__polyfit_exponents[idx_row]
                vb[idx_row,0] = np.dot(b, x**n_row)
                for idx_col in range(nr):
                    n_col = self.__polyfit_exponents[idx_col]
                    vm[idx_row, idx_col] = np.sum(x**(n_row+n_col))
            neg_coeffs = np.linalg.solve(vm, vb)[:,0]
            
            return (pos_coeffs,neg_coeffs)
                    
        self._bx_pos_coeffs, self._bx_neg_coeffs = [], []
        self._by_pos_coeffs, self._by_neg_coeffs = [], []
        self._bz_pos_coeffs, self._bz_neg_coeffs = [], []
        self.bx_missing_integral = []
        self.by_missing_integral = []
        self.bz_missing_integral = []
            
        for yplane_idx in range(len(self.by)):
            bx_pos_coeffs, by_pos_coeffs, bz_pos_coeffs = [], [], []
            bx_neg_coeffs, by_neg_coeffs, bz_neg_coeffs = [], [], []
            bx_missing_integral, by_missing_integral, bz_missing_integral = [], [], []
            for fieldline_idx in range(self.by[yplane_idx].shape[0]):
                #print(fieldline_idx)
                # bx
                pos_coeff, neg_coeff = calc_poly_coeffs(yplane_idx, fieldline_idx, self.bx)
                bx_pos_coeffs.append(pos_coeff)
                bx_neg_coeffs.append(neg_coeff)
                binteg  = self.integral_z(coeffs = pos_coeff, rz_inf = self.rz_max, rz_sup = float('inf'))
                binteg += self.integral_z(coeffs = neg_coeff, rz_inf = -float('inf'), rz_sup = self.rz_min)
                bx_missing_integral.append(binteg) 
                # by
                pos_coeff, neg_coeff = calc_poly_coeffs(yplane_idx, fieldline_idx, self.by)
                by_pos_coeffs.append(pos_coeff)
                by_neg_coeffs.append(neg_coeff)
                binteg  = self.integral_z(coeffs = pos_coeff, rz_inf = self.rz_max, rz_sup = float('inf'))
                binteg += self.integral_z(coeffs = neg_coeff, rz_inf = -float('inf'), rz_sup = self.rz_min)
                by_missing_integral.append(binteg)
                # bz
                pos_coeff, neg_coeff = calc_poly_coeffs(yplane_idx, fieldline_idx, self.bz)
                bz_pos_coeffs.append(pos_coeff)
                bz_neg_coeffs.append(neg_coeff)
                binteg  = self.integral_z(coeffs = pos_coeff, rz_inf = self.rz_max, rz_sup = float('inf'))
                binteg += self.integral_z(coeffs = neg_coeff, rz_inf = -float('inf'), rz_sup = self.rz_min)
                bz_missing_integral.append(binteg)
             
            self._bx_pos_coeffs.append(bx_pos_coeffs)
            self._bx_neg_coeffs.append(bx_neg_coeffs)
            self._by_pos_coeffs.append(by_pos_coeffs)
            self._by_neg_coeffs.append(by_neg_coeffs)
            self._bz_pos_coeffs.append(bz_pos_coeffs)
            self._bz_neg_coeffs.append(bz_neg_coeffs)
            self.bx_missing_integral.append(bx_missing_integral)
            self.by_missing_integral.append(by_missing_integral)
            self.bz_missing_integral.append(bz_missing_integral)
      
    def __str__(self):
        r = ''
        r += '{0:<35s} {1}'.format('timestamp:', self.timestamp)
        r += '\n{0:<35s} {1}'.format('filename:', self.filename)
        r += '\n{0:<35s} {1}'.format('magnet_label:', self.magnet_label)
        r += '\n{0:<35s} {1} mm'.format('magnet_length:', self.length)
        r += '\n{0:<35s} {1} A'.format('main_coil_current:', self.current)
        try:
            r += '\n{0:<35s} {1} mm'.format('magnetic_gap:', self.gap)
        except:
            pass
        try:
            r += '\n{0:<35s} {1} mm'.format('control_gap:', self.control_gap)
        except:
            pass
  
        if self.ry_nrpts == 1: 
            r += '\n{0:<35s} {3} point in [{1},{2}] mm (step of {4:f} mm)'.format('ry_grid:', self.ry_min, self.ry_max, self.ry_nrpts, self.ry_step)
        else:
            r += '\n{0:<35s} {3} points in [{1},{2}] mm (step of {4:f} mm)'.format('ry_grid:', self.ry_min, self.ry_max, self.ry_nrpts, self.ry_step)
        if self.rx_nrpts == 1: 
            r += '\n{0:<35s} {3} point in [{1},{2}] mm (step of {4:f} mm)'.format('rx_grid:', self.rx_min, self.rx_max, self.rx_nrpts, self.rx_step)
        else:
            r += '\n{0:<35s} {3} points in [{1},{2}] mm (step of {4:f} mm)'.format('rx_grid:', self.rx_min, self.rx_max, self.rx_nrpts, self.rx_step)
        if self.rz_nrpts == 1: 
            r += '\n{0:<35s} {3} point in [{1},{2}] mm (step of {4:f} mm)'.format('rz_grid:', self.rz_min, self.rz_max, self.rz_nrpts, self.rz_step)
        else:
            r += '\n{0:<35s} {3} points in [{1},{2}] mm (step of {4:f} mm)'.format('rz_grid:', self.rz_min, self.rz_max, self.rz_nrpts, self.rz_step)    
        r += '\n{0:<35s} (min:{1:+8.5f} max:{2:+8.5f}) (min:{3:+8.5f} max:{4:+8.5f}) Tesla'.format('by@(all)(axis):', 
        np.amin(self.by[self.ry_zero]), np.amax(self.by[self.ry_zero]), min(self.by[self.ry_zero][self.rx_zero]), max(self.by[self.ry_zero][self.rx_zero])) 
        r += '\n{0:<35s} (min:{1:+8.5f} max:{2:+8.5f}) (min:{3:+8.5f} max:{4:+8.5f}) Tesla'.format('bx@(all)(axis):', 
        np.amin(self.bx[self.ry_zero]), np.amax(self.bx[self.ry_zero]), min(self.bx[self.ry_zero][self.rx_zero]), max(self.bx[self.ry_zero][self.rx_zero])) 
        r += '\n{0:<35s} (min:{1:+8.5f} max:{2:+8.5f}) (min:{3:+8.5f} max:{4:+8.5f}) Tesla'.format('bz@(all)(axis):', 
        np.amin(self.bz[self.ry_zero]), np.amax(self.bz[self.ry_zero]), min(self.bz[self.ry_zero][self.rx_zero]), max(self.bz[self.ry_zero][self.rx_zero]))
        
        if self.bx_missing_integral is not None:
            missing_Lbx = [abs(x) for x in self.bx_missing_integral[self.ry_zero]]
            max_missing_Lbx = max(missing_Lbx)
            rx_max = missing_Lbx.index(max_missing_Lbx)
            r += '\n{0:<35s} {1:.2E} T.m at rx = {2:+d} mm'.format('missing_int{Bx.drz}(max):', max_missing_Lbx/1000, rx_max)
        if self.by_missing_integral is not None:
            missing_Lby = [abs(x) for x in self.by_missing_integral[self.ry_zero]]
            max_missing_Lby = max(missing_Lby)
            rx_max = missing_Lby.index(max_missing_Lby)
            r += '\n{0:<35s} {1:.2E} T.m at rx = {2:+d} mm'.format('missing_int{By.drz}(max):', max_missing_Lby/1000, rx_max)
        if self.bz_missing_integral is not None:
            missing_Lbz = [abs(x) for x in self.bz_missing_integral[self.ry_zero]]
            max_missing_Lbz = max(missing_Lbz)
            rx_max = missing_Lbz.index(max_missing_Lbz)
            r += '\n{0:<35s} {1:.2E} T.m at rx = {2:+d} mm'.format('missing_int{Bz.drz}(max):', max_missing_Lbz/1000, rx_max)
        return r
      
            