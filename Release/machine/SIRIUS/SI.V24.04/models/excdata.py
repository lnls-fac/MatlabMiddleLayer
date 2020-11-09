#!/usr/bin/env python-sirius

import numpy as np
import matplotlib.pyplot as plt


SORTING = [
    'SI-01M2:MA-QDA', 'Q14-081',
    'SI-05M1:MA-QDA', 'Q14-077',
    'SI-05M2:MA-QDA', 'Q14-028',
    'SI-09M1:MA-QDA', 'Q14-059',
    'SI-09M2:MA-QDA', 'Q14-062',
    'SI-13M1:MA-QDA', 'Q14-058',
    'SI-13M2:MA-QDA', 'Q14-040',
    'SI-17M1:MA-QDA', 'Q14-034',
    'SI-17M2:MA-QDA', 'Q14-068',
    'SI-01M1:MA-QDA', 'Q14-018',
    'SI-02M1:MA-QDB1', 'Q14-010',
    'SI-02M2:MA-QDB1', 'Q14-017',
    'SI-04M1:MA-QDB1', 'Q14-011',
    'SI-04M2:MA-QDB1', 'Q14-008',
    'SI-06M1:MA-QDB1', 'Q14-023',
    'SI-06M2:MA-QDB1', 'Q14-035',
    'SI-08M1:MA-QDB1', 'Q14-048',
    'SI-08M2:MA-QDB1', 'Q14-075',
    'SI-10M1:MA-QDB1', 'Q14-021',
    'SI-10M2:MA-QDB1', 'Q14-055',
    'SI-12M1:MA-QDB1', 'Q14-014',
    'SI-12M2:MA-QDB1', 'Q14-033',
    'SI-14M1:MA-QDB1', 'Q14-026',
    'SI-14M2:MA-QDB1', 'Q14-067',
    'SI-16M1:MA-QDB1', 'Q14-057',
    'SI-16M2:MA-QDB1', 'Q14-027',
    'SI-18M1:MA-QDB1', 'Q14-079',
    'SI-18M2:MA-QDB1', 'Q14-009',
    'SI-20M1:MA-QDB1', 'Q14-025',
    'SI-20M2:MA-QDB1', 'Q14-053',
    'SI-02M1:MA-QDB2', 'Q14-039',
    'SI-02M2:MA-QDB2', 'Q14-050',
    'SI-04M1:MA-QDB2', 'Q14-038',
    'SI-04M2:MA-QDB2', 'Q14-020',
    'SI-06M1:MA-QDB2', 'Q14-045',
    'SI-06M2:MA-QDB2', 'Q14-047',
    'SI-08M1:MA-QDB2', 'Q14-064',
    'SI-08M2:MA-QDB2', 'Q14-046',
    'SI-10M1:MA-QDB2', 'Q14-032',
    'SI-10M2:MA-QDB2', 'Q14-030',
    'SI-12M1:MA-QDB2', 'Q14-065',
    'SI-12M2:MA-QDB2', 'Q14-056',
    'SI-14M1:MA-QDB2', 'Q14-049',
    'SI-14M2:MA-QDB2', 'Q14-054',
    'SI-16M1:MA-QDB2', 'Q14-063',
    'SI-16M2:MA-QDB2', 'Q14-004',
    'SI-18M1:MA-QDB2', 'Q14-015',
    'SI-18M2:MA-QDB2', 'Q14-066',
    'SI-20M1:MA-QDB2', 'Q14-060',
    'SI-20M2:MA-QDB2', 'Q14-052',
    'SI-03M1:MA-QDP1', 'Q14-069',
    'SI-03M2:MA-QDP1', 'Q14-072',
    'SI-07M1:MA-QDP1', 'Q14-019',
    'SI-07M2:MA-QDP1', 'Q14-031',
    'SI-11M1:MA-QDP1', 'Q14-041',
    'SI-11M2:MA-QDP1', 'Q14-070',
    'SI-15M1:MA-QDP1', 'Q14-051',
    'SI-15M2:MA-QDP1', 'Q14-042',
    'SI-19M1:MA-QDP1', 'Q14-029',
    'SI-19M2:MA-QDP1', 'Q14-061',
    'SI-03M1:MA-QDP2', 'Q14-012',
    'SI-03M2:MA-QDP2', 'Q14-005',
    'SI-07M1:MA-QDP2', 'Q14-078',
    'SI-07M2:MA-QDP2', 'Q14-071',
    'SI-11M1:MA-QDP2', 'Q14-007',
    'SI-11M2:MA-QDP2', 'Q14-006',
    'SI-15M1:MA-QDP2', 'Q14-073',
    'SI-15M2:MA-QDP2', 'Q14-016',
    'SI-19M1:MA-QDP2', 'Q14-037',
    'SI-19M2:MA-QDP2', 'Q14-002',
    'SI-01M2:MA-QFA', 'Q20-076',
    'SI-05M1:MA-QFA', 'Q20-079',
    'SI-05M2:MA-QFA', 'Q20-176',
    'SI-09M1:MA-QFA', 'Q20-074',
    'SI-09M2:MA-QFA', 'Q20-101',
    'SI-13M1:MA-QFA', 'Q20-162',
    'SI-13M2:MA-QFA', 'Q20-155',
    'SI-17M1:MA-QFA', 'Q20-095',
    'SI-17M2:MA-QFA', 'Q20-071',
    'SI-01M1:MA-QFA', 'Q20-049',
    'SI-01C1:MA-Q1', 'Q20-030',
    'SI-01C4:MA-Q1', 'Q20-132',
    'SI-02C1:MA-Q1', 'Q20-013',
    'SI-02C4:MA-Q1', 'Q20-014',
    'SI-03C1:MA-Q1', 'Q20-027',
    'SI-03C4:MA-Q1', 'Q20-008',
    'SI-04C1:MA-Q1', 'Q20-029',
    'SI-04C4:MA-Q1', 'Q20-023',
    'SI-05C1:MA-Q1', 'Q20-149',
    'SI-05C4:MA-Q1', 'Q20-028',
    'SI-06C1:MA-Q1', 'Q20-036',
    'SI-06C4:MA-Q1', 'Q20-033',
    'SI-07C1:MA-Q1', 'Q20-020',
    'SI-07C4:MA-Q1', 'Q20-015',
    'SI-08C1:MA-Q1', 'Q20-125',
    'SI-08C4:MA-Q1', 'Q20-153',
    'SI-09C1:MA-Q1', 'Q20-025',
    'SI-09C4:MA-Q1', 'Q20-067',
    'SI-10C1:MA-Q1', 'Q20-035',
    'SI-10C4:MA-Q1', 'Q20-141',
    'SI-11C1:MA-Q1', 'Q20-119',
    'SI-11C4:MA-Q1', 'Q20-012',
    'SI-12C1:MA-Q1', 'Q20-111',
    'SI-12C4:MA-Q1', 'Q20-006',
    'SI-13C1:MA-Q1', 'Q20-164',
    'SI-13C4:MA-Q1', 'Q20-024',
    'SI-14C1:MA-Q1', 'Q20-010',
    'SI-14C4:MA-Q1', 'Q20-032',
    'SI-15C1:MA-Q1', 'Q20-011',
    'SI-15C4:MA-Q1', 'Q20-005',
    'SI-16C1:MA-Q1', 'Q20-039',
    'SI-16C4:MA-Q1', 'Q20-109',
    'SI-17C1:MA-Q1', 'Q20-016',
    'SI-17C4:MA-Q1', 'Q20-009',
    'SI-18C1:MA-Q1', 'Q20-026',
    'SI-18C4:MA-Q1', 'Q20-037',
    'SI-19C1:MA-Q1', 'Q20-038',
    'SI-19C4:MA-Q1', 'Q20-017',
    'SI-20C1:MA-Q1', 'Q20-007',
    'SI-20C4:MA-Q1', 'Q20-021',
    'SI-01C1:MA-Q2', 'Q20-096',
    'SI-01C4:MA-Q2', 'Q20-034',
    'SI-02C1:MA-Q2', 'Q20-092',
    'SI-02C4:MA-Q2', 'Q20-122',
    'SI-03C1:MA-Q2', 'Q20-136',
    'SI-03C4:MA-Q2', 'Q20-174',
    'SI-04C1:MA-Q2', 'Q20-056',
    'SI-04C4:MA-Q2', 'Q20-059',
    'SI-05C1:MA-Q2', 'Q20-128',
    'SI-05C4:MA-Q2', 'Q20-115',
    'SI-06C1:MA-Q2', 'Q20-126',
    'SI-06C4:MA-Q2', 'Q20-158',
    'SI-07C1:MA-Q2', 'Q20-073',
    'SI-07C4:MA-Q2', 'Q20-087',
    'SI-08C1:MA-Q2', 'Q20-137',
    'SI-08C4:MA-Q2', 'Q20-082',
    'SI-09C1:MA-Q2', 'Q20-050',
    'SI-09C4:MA-Q2', 'Q20-117',
    'SI-10C1:MA-Q2', 'Q20-105',
    'SI-10C4:MA-Q2', 'Q20-124',
    'SI-11C1:MA-Q2', 'Q20-120',
    'SI-11C4:MA-Q2', 'Q20-118',
    'SI-12C1:MA-Q2', 'Q20-134',
    'SI-12C4:MA-Q2', 'Q20-135',
    'SI-13C1:MA-Q2', 'Q20-068',
    'SI-13C4:MA-Q2', 'Q20-098',
    'SI-14C1:MA-Q2', 'Q20-072',
    'SI-14C4:MA-Q2', 'Q20-175',
    'SI-15C1:MA-Q2', 'Q20-178',
    'SI-15C4:MA-Q2', 'Q20-104',
    'SI-16C1:MA-Q2', 'Q20-046',
    'SI-16C4:MA-Q2', 'Q20-154',
    'SI-17C1:MA-Q2', 'Q20-167',
    'SI-17C4:MA-Q2', 'Q20-094',
    'SI-18C1:MA-Q2', 'Q20-062',
    'SI-18C4:MA-Q2', 'Q20-102',
    'SI-19C1:MA-Q2', 'Q20-131',
    'SI-19C4:MA-Q2', 'Q20-138',
    'SI-20C1:MA-Q2', 'Q20-065',
    'SI-20C4:MA-Q2', 'Q20-152',
    'SI-01C2:MA-Q3', 'Q20-066',
    'SI-01C3:MA-Q3', 'Q20-061',
    'SI-02C2:MA-Q3', 'Q20-091',
    'SI-02C3:MA-Q3', 'Q20-004',
    'SI-03C2:MA-Q3', 'Q20-147',
    'SI-03C3:MA-Q3', 'Q20-114',
    'SI-04C2:MA-Q3', 'Q20-112',
    'SI-04C3:MA-Q3', 'Q20-165',
    'SI-05C2:MA-Q3', 'Q20-107',
    'SI-05C3:MA-Q3', 'Q20-019',
    'SI-06C2:MA-Q3', 'Q20-179',
    'SI-06C3:MA-Q3', 'Q20-106',
    'SI-07C2:MA-Q3', 'Q20-148',
    'SI-07C3:MA-Q3', 'Q20-108',
    'SI-08C2:MA-Q3', 'Q20-070',
    'SI-08C3:MA-Q3', 'Q20-159',
    'SI-09C2:MA-Q3', 'Q20-121',
    'SI-09C3:MA-Q3', 'Q20-045',
    'SI-10C2:MA-Q3', 'Q20-042',
    'SI-10C3:MA-Q3', 'Q20-130',
    'SI-11C2:MA-Q3', 'Q20-161',
    'SI-11C3:MA-Q3', 'Q20-075',
    'SI-12C2:MA-Q3', 'Q20-127',
    'SI-12C3:MA-Q3', 'Q20-022',
    'SI-13C2:MA-Q3', 'Q20-145',
    'SI-13C3:MA-Q3', 'Q20-133',
    'SI-14C2:MA-Q3', 'Q20-172',
    'SI-14C3:MA-Q3', 'Q20-129',
    'SI-15C2:MA-Q3', 'Q20-018',
    'SI-15C3:MA-Q3', 'Q20-142',
    'SI-16C2:MA-Q3', 'Q20-139',
    'SI-16C3:MA-Q3', 'Q20-113',
    'SI-17C2:MA-Q3', 'Q20-140',
    'SI-17C3:MA-Q3', 'Q20-170',
    'SI-18C2:MA-Q3', 'Q20-110',
    'SI-18C3:MA-Q3', 'Q20-044',
    'SI-19C2:MA-Q3', 'Q20-086',
    'SI-19C3:MA-Q3', 'Q20-177',
    'SI-20C2:MA-Q3', 'Q20-031',
    'SI-20C3:MA-Q3', 'Q20-064',
    'SI-01C2:MA-Q4', 'Q20-081',
    'SI-01C3:MA-Q4', 'Q20-097',
    'SI-02C2:MA-Q4', 'Q20-051',
    'SI-02C3:MA-Q4', 'Q20-168',
    'SI-03C2:MA-Q4', 'Q20-166',
    'SI-03C3:MA-Q4', 'Q20-043',
    'SI-04C2:MA-Q4', 'Q20-080',
    'SI-04C3:MA-Q4', 'Q20-047',
    'SI-05C2:MA-Q4', 'Q20-163',
    'SI-05C3:MA-Q4', 'Q20-048',
    'SI-06C2:MA-Q4', 'Q20-103',
    'SI-06C3:MA-Q4', 'Q20-116',
    'SI-07C2:MA-Q4', 'Q20-089',
    'SI-07C3:MA-Q4', 'Q20-077',
    'SI-08C2:MA-Q4', 'Q20-093',
    'SI-08C3:MA-Q4', 'Q20-063',
    'SI-09C2:MA-Q4', 'Q20-100',
    'SI-09C3:MA-Q4', 'Q20-054',
    'SI-10C2:MA-Q4', 'Q20-156',
    'SI-10C3:MA-Q4', 'Q20-169',
    'SI-11C2:MA-Q4', 'Q20-057',
    'SI-11C3:MA-Q4', 'Q20-058',
    'SI-12C2:MA-Q4', 'Q20-090',
    'SI-12C3:MA-Q4', 'Q20-150',
    'SI-13C2:MA-Q4', 'Q20-144',
    'SI-13C3:MA-Q4', 'Q20-085',
    'SI-14C2:MA-Q4', 'Q20-052',
    'SI-14C3:MA-Q4', 'Q20-069',
    'SI-15C2:MA-Q4', 'Q20-123',
    'SI-15C3:MA-Q4', 'Q20-084',
    'SI-16C2:MA-Q4', 'Q20-143',
    'SI-16C3:MA-Q4', 'Q20-171',
    'SI-17C2:MA-Q4', 'Q20-053',
    'SI-17C3:MA-Q4', 'Q20-157',
    'SI-18C2:MA-Q4', 'Q20-078',
    'SI-18C3:MA-Q4', 'Q20-146',
    'SI-19C2:MA-Q4', 'Q20-060',
    'SI-19C3:MA-Q4', 'Q20-160',
    'SI-20C2:MA-Q4', 'Q20-173',
    'SI-20C3:MA-Q4', 'Q20-083',
    'SI-02M1:MA-QFB', 'Q30-016',
    'SI-02M2:MA-QFB', 'Q30-032',
    'SI-04M1:MA-QFB', 'Q30-010',
    'SI-04M2:MA-QFB', 'Q30-019',
    'SI-06M1:MA-QFB', 'Q30-008',
    'SI-06M2:MA-QFB', 'Q30-036',
    'SI-08M1:MA-QFB', 'Q30-011',
    'SI-08M2:MA-QFB', 'Q30-035',
    'SI-10M1:MA-QFB', 'Q30-009',
    'SI-10M2:MA-QFB', 'Q30-020',
    'SI-12M1:MA-QFB', 'Q30-029',
    'SI-12M2:MA-QFB', 'Q30-014',
    'SI-14M1:MA-QFB', 'Q30-013',
    'SI-14M2:MA-QFB', 'Q30-024',
    'SI-16M1:MA-QFB', 'Q30-005',
    'SI-16M2:MA-QFB', 'Q30-021',
    'SI-18M1:MA-QFB', 'Q30-025',
    'SI-18M2:MA-QFB', 'Q30-030',
    'SI-20M1:MA-QFB', 'Q30-023',
    'SI-20M2:MA-QFB', 'Q30-022',
    'SI-03M1:MA-QFP', 'Q30-033',
    'SI-03M2:MA-QFP', 'Q30-027',
    'SI-07M1:MA-QFP', 'Q30-017',
    'SI-07M2:MA-QFP', 'Q30-006',
    'SI-11M1:MA-QFP', 'Q30-026',
    'SI-11M2:MA-QFP', 'Q30-034',
    'SI-15M1:MA-QFP', 'Q30-015',
    'SI-15M2:MA-QFP', 'Q30-031',
    'SI-19M1:MA-QFP', 'Q30-007',
    'SI-19M2:MA-QFP', 'Q30-004',
]

q14_fnames = [
    './quadrupoles-q14/MULTIPOLES-2A.txt',
    './quadrupoles-q14/MULTIPOLES-4A.txt',
    './quadrupoles-q14/MULTIPOLES-6A.txt',
    './quadrupoles-q14/MULTIPOLES-8A.txt',
    './quadrupoles-q14/MULTIPOLES-10A.txt',
    './quadrupoles-q14/MULTIPOLES-30A.txt',
    './quadrupoles-q14/MULTIPOLES-50A.txt',
    './quadrupoles-q14/MULTIPOLES-70A.txt',
    './quadrupoles-q14/MULTIPOLES-90A.txt',
    './quadrupoles-q14/MULTIPOLES-110A.txt',
    './quadrupoles-q14/MULTIPOLES-130A.txt',
    './quadrupoles-q14/MULTIPOLES-148A.txt',
    ]


q20_fnames = [
    './quadrupoles-q20/MULTIPOLES-2A.txt',
    './quadrupoles-q20/MULTIPOLES-4A.txt',
    './quadrupoles-q20/MULTIPOLES-6A.txt',
    './quadrupoles-q20/MULTIPOLES-8A.txt',
    './quadrupoles-q20/MULTIPOLES-10A.txt',
    './quadrupoles-q20/MULTIPOLES-30A.txt',
    './quadrupoles-q20/MULTIPOLES-50A.txt',
    './quadrupoles-q20/MULTIPOLES-70A.txt',
    './quadrupoles-q20/MULTIPOLES-90A.txt',
    './quadrupoles-q20/MULTIPOLES-110A.txt',
    './quadrupoles-q20/MULTIPOLES-130A.txt',
    './quadrupoles-q20/MULTIPOLES-157A.txt',
    ]


q30_fnames = [
    './quadrupoles-q30/MULTIPOLES-2A.txt',
    './quadrupoles-q30/MULTIPOLES-4A.txt',
    './quadrupoles-q30/MULTIPOLES-6A.txt',
    './quadrupoles-q30/MULTIPOLES-8A.txt',
    './quadrupoles-q30/MULTIPOLES-10A.txt',
    './quadrupoles-q30/MULTIPOLES-30A.txt',
    './quadrupoles-q30/MULTIPOLES-50A.txt',
    './quadrupoles-q30/MULTIPOLES-70A.txt',
    './quadrupoles-q30/MULTIPOLES-90A.txt',
    './quadrupoles-q30/MULTIPOLES-110A.txt',
    './quadrupoles-q30/MULTIPOLES-130A.txt',
    './quadrupoles-q30/MULTIPOLES-155A.txt',
    ]


def get_sorting():
    magnets = SORTING[::2]
    serials = SORTING[1::2]
    fams = dict()
    for magnet, serial in zip(magnets, serials):
        fam = magnet.split('-')[2]
        if fam not in fams:
            fams[fam] = [serial]
        else:
            fams[fam].append(serial)
    return fams


def multipole_plot(magnets, currents, harmonics, multipoles_normal, multipoles_skew, harm, typ):
    idx = harmonics.index(harm)
    if typ == 'normal':
        data = multipoles_normal[:, idx]
        title = 'Normal'
    else:
        data = multipoles_skew[:, idx]
        title = 'Skew'
    title += ' multipole values for harmonic n = {}'.format(harm)
    
    data = data * currents
    fig, ax = plt.subplots()
    x = np.arange(len(magnets))
    ax.bar(x, data)
    ax.set_title(title)
    ax.set_xlabel('Integrated multipole [T/m^(n-1)]'.format(harm))
    ax.set_ylabel('Integrated multipole [T/m^(n-1)]'.format(harm))
    ax.set_xticks(x)
    ax.set_xticklabels(magnets, rotation=90)
    plt.show()


def multipole_read_file(fname):

    with open(fname, 'r') as fp:
        lines = fp.readlines()

    magnets = list()
    harmonics = list()
    currents = list()    
    multipoles_normal = list()
    multipoles_skew = list()
    for line in lines:
        line = line.strip()
        if line.startswith('#'):
            if '# harmonics' in line:
                _, harmonics = line.split('):')
                harmonics = [int(word) for word in harmonics.split()]
                # print(harmonics)
            continue
        magnet, current, *mpoles = line.split()
        mpoles = [float(mpole) for mpole in mpoles]
        # first column: magnet name
        magnets.append(magnet)
        # second column: measurement current
        currents.append(float(current))
        # next group: normal multipoles for all harmonics, normalized by excitation current
        multipoles_normal.append(mpoles[:len(harmonics)])
        # next group: skew multipoles for all harmonics, normalized by excitation current
        multipoles_skew.append(mpoles[len(harmonics):])

    currents = np.array(currents)
    multipoles_normal = np.array(multipoles_normal)
    multipoles_skew = np.array(multipoles_skew)
    
    return magnets, currents, harmonics, multipoles_normal, multipoles_skew


def multipole_get_avg(fname, magnets_fam, exclude_harms):
    magnets, currents, harmonics, multipoles_normal, multipoles_skew = multipole_read_file(fname)
    indices = [magnets.index(mag) for mag in magnets_fam]
    selection = \
        list(set(np.arange(len(harmonics))) - set([harmonics.index(h) for h in exclude_harms]))
    # print(selection)

    nmpoles = multipoles_normal[:, selection]
    smpoles = multipoles_skew[:, selection]
    nmpoles = nmpoles[indices, :] 
    smpoles = smpoles[indices, :]
    currents = currents[indices]
    for i in range(len(currents)):
        nmpoles[i, :] *= currents[i]
        smpoles[i, :] *= currents[i]
    
    current = np.mean(currents)
    nmpoles = np.mean(nmpoles, 0)
    smpoles = np.mean(smpoles, 0)

    return current, harmonics, nmpoles, smpoles


def excdata_print(fam, fnames, exclude_harms, label, main_harmonic):

    fams = get_sorting()
    magnets_fam = fams[fam]
    
    # get data from file and build 
    excdata = list()
    for fname in fnames:
        current, harmonics, nmpoles, smpoles = multipole_get_avg(fname, magnets_fam, exclude_harms)
        datum = np.array([0.0, ] * (1 + len(nmpoles) + len(smpoles)))
        datum[0] = current
        datum[1::2] = nmpoles
        datum[2::2] = smpoles
        excdata.append(datum)
    
    
    datum1 = excdata[0]
    datum2 = excdata[1]
    x1, x2 = datum1[0], datum2[0]
    y1, y2 = np.array(datum1[1:]), np.array(datum2[1:])
    b = (x2 * y1 - x1 * y2) / (x2 - x1)
    excdata.insert(0, [0,] + list(b))
    excdata = np.array(excdata)

    print('# HEADER')
    print('# ======')
    print('# label             {}'.format(label))
    print('# harmonics         ', end='')
    for h in harmonics:
        if h not in exclude_harms:
            print('{} '.format(h), end='')
    print()
    print('# main_harmonic     {}'.format(main_harmonic))
    print('# rescaling factor  1.002908')
    print('# units             Ampere  ', end='')
    for h in harmonics:
        if h not in exclude_harms:
            if h == 0:
                fmt = 'T*m'
            elif h == 1:
                fmt = 'T'
            elif h == 2:
                fmt = 'T/m'
            else:
                fmt = 'T/m^{}'.format(h-1)
            print('{} {}  '.format(fmt, fmt), end='')
    print()
    print()
    print('# EXCITATION DATA')
    print('# ===============')

    for line in excdata:
        print('{:+09.4f} '.format(line[0]), end='')
        for i in range(len(line[1:])//2):
            if harmonics[i] not in exclude_harms:
                print('{:+.4e} {:+.4e}  '.format(line[1+2*i+0], line[1+2*i+1]), end='')
        print()
    print()

    print('# COMMENTS')
    print('# ========')
    print('# 1. generated automatically with "excdata.py"')
    print('# 2. data taken from rotcoil measurements')
    print('# 3. data for zero current is extrapolated from data points with lowest measured currents')
    print('# 4. average excitation curves for magnets:', end='')
    for i in range(len(magnets_fam)):
        if i % 10 == 0:
            print('\n#    ', end='')
        print('{} '.format(magnets_fam[i]), end='')
    print()

    print()
    print('# POLARITY TABLE')
    print('# ==============')
    print('#')
    print('# Magnet function         | IntStrength(1) | IntField(2) | ConvSign(3) | Current(4)')
    print('# ------------------------|----------------|-------------|-------------|-----------')
    print('# dipole                  | Angle > 0      | BYL  < 0    | -1.0        | I > 0')
    print('# corrector-horizontal    | HKick > 0      | BYL  > 0    | +1.0        | I > 0')
    print('# corrector-vertical      | VKick > 0      | BXL  < 0    | -1.0        | I > 0')
    print('# quadrupole (focusing)   | KL    > 0      | D1NL < 0    | -1.0        | I > 0')
    print('# quadrupole (defocusing) | KL    < 0      | D1NL > 0    | -1.0        | I > 0')
    print('# quadrupole (skew)       | KL    < 0      | D1SL > 0    | -1.0        | I > 0')
    print('# sextupole  (focusing)   | SL    > 0      | D2NL < 0    | -1.0        | I > 0')
    print('# sextupole  (defocusing) | SL    < 0      | D2NL > 0    | -1.0        | I > 0')
    print('#')
    print('# Defs:')
    print('# ----')
    print('# BYL   := \int{dz By|_{x=y=0}}.')
    print('# BXL   := \int{dz Bx|_{x=y=0}}.')
    print('# D1NL  := \int{dz \\frac{dBy}{dx}_{x=y=0}}')
    print('# D2NL  := (1/2!) \int{dz \\frac{d^2By}{dx^2}_{x=y=0}}')
    print('# D1SL  := \int{dz \\frac{dBx}{dx}_{x=y=0}}')
    print('# Brho  := magnetic rigidity.')
    print('# Angle := ConvSign * BYL / abs(Brho)')
    print('# HKick := ConvSign * BYL / abs(Brho)')
    print('# VKick := ConvSign * BXL / abs(Brho)')
    print('# KL    := ConvSign * D1NL / abs(Brho)')
    print('# KL    := ConvSign * D1SL / abs(Brho)')
    print('# SL    := ConvSign * D2NL / abs(Brho)')
    print('#')
    print('# Obs:')
    print('# ---')
    print('# (1) Parameter definition.')
    print('#     IntStrength values correspond to integrated PolynomA and PolynomB parameters')
    print('#     of usual beam tracking codes, with the exception that VKick has its sign')
    print('#     reversed with respecto to its corresponding value in PolynomA.')
    print('# (2) Sirius coordinate system and Lorentz force.')
    print('# (3) Conversion sign for IntField <-> IntStrength')
    print('# (4) Convention of magnet excitation polarity, so that when I > 0 the strength')
    print('#     of the magnet has the expected conventional sign.')
    print('')
    print('# STATIC DATA FILE FORMAT')
    print('# =======================')
    print('#')
    print('# These static data files should comply with the following formatting rules:')
    print('# 1. If the first alphanumeric character of the line is not the pound sign')
    print('#    then the lines is a comment.')
    print('# 2. If the first alphanumeric character is "#" then if')
    print('#    a) it is followed by "[<parameter>] <value>" a parameter names <parameter>')
    print('#       is define with value <value>. if the string <value> has spaces in it')
    print('#       it is split as a list of strings.')
    print('#    b) otherwise the line is ignored as a comment line.')

    return harmonics, excdata


def excdata_QDA():

    fam = 'QDA'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q14_fnames
    label = 'si-quadrupole-q14-qda-fam'
    main_harmonic = '1 normal'

    harmonics, excdata = excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata = np.array(excdata)

    currents = excdata[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QDA Family Excitation Curve')
    plt.show()


def excdata_QDB1():

    fam = 'QDB1'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q14_fnames
    label = 'si-quadrupole-q14-qdb1-fam'
    main_harmonic = '1 normal'

    harmonics, excdata = excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata = np.array(excdata)

    currents = excdata[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QDB1 Family Excitation Curve')
    plt.show()


def excdata_QDB2():

    fam = 'QDB2'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q14_fnames
    label = 'si-quadrupole-q14-qdb2-fam'
    main_harmonic = '1 normal'

    harmonics, excdata = excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata = np.array(excdata)

    currents = excdata[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QDB2 Family Excitation Curve')
    plt.show()


def excdata_QDP1():

    fam = 'QDP1'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q14_fnames
    label = 'si-quadrupole-q14-qdp1-fam'
    main_harmonic = '1 normal'

    harmonics, excdata = excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata = np.array(excdata)

    currents = excdata[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QDP1 Family Excitation Curve')
    plt.show()


def excdata_QDP2():

    fam = 'QDP2'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q14_fnames
    label = 'si-quadrupole-q14-qdp2-fam'
    main_harmonic = '1 normal'

    harmonics, excdata = excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata = np.array(excdata)

    currents = excdata[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QDP2 Family Excitation Curve')
    plt.show()


def excdata_QFA():

    fam = 'QFA'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q20_fnames
    label = 'si-quadrupole-q20-qfa-fam'
    main_harmonic = '1 normal'

    harmonics, excdata = excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata = np.array(excdata)

    currents = excdata[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QFA Family Excitation Curve')
    plt.show()


def excdata_Q1():

    fam = 'Q1'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q20_fnames
    label = 'si-quadrupole-q20-q1-fam'
    main_harmonic = '1 normal'

    harmonics, excdata = excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata = np.array(excdata)

    currents = excdata[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('Q1 Family Excitation Curve')
    plt.show()


def excdata_Q2():

    fam = 'Q2'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q20_fnames
    label = 'si-quadrupole-q20-q2-fam'
    main_harmonic = '1 normal'

    harmonics, excdata = excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata = np.array(excdata)

    currents = excdata[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('Q2 Family Excitation Curve')
    plt.show()


def excdata_Q3():

    fam = 'Q3'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q20_fnames
    label = 'si-quadrupole-q20-q3-fam'
    main_harmonic = '1 normal'

    harmonics, excdata = excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata = np.array(excdata)

    currents = excdata[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('Q3 Family Excitation Curve')
    plt.show()


def excdata_Q4():

    fam = 'Q4'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q20_fnames
    label = 'si-quadrupole-q20-q4-fam'
    main_harmonic = '1 normal'

    harmonics, excdata = excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata = np.array(excdata)

    currents = excdata[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('Q4 Family Excitation Curve')
    plt.show()


def excdata_QFB():

    fam = 'QFB'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q30_fnames
    label = 'si-quadrupole-q30-qfb-fam'
    main_harmonic = '1 normal'

    harmonics, excdata = excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata = np.array(excdata)

    currents = excdata[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QFB Family Excitation Curve')
    plt.show()


def excdata_QFP():

    fam = 'QFP'
    # exclude_harms = [0, ]
    exclude_harms = [ ]
    fnames = q30_fnames
    label = 'si-quadrupole-q30-qfp-fam'
    main_harmonic = '1 normal'

    harmonics, excdata = excdata_print(fam, fnames, exclude_harms, label, main_harmonic)

    excdata = np.array(excdata)

    currents = excdata[:, 0]
    idx = harmonics.index(1)
    plt.plot(currents, excdata[:, 1 + 2*idx], 'o--')
    plt.xlabel('Current [A]')
    plt.ylabel('GL [T]')
    plt.grid()
    plt.title('QFP Family Excitation Curve')
    plt.show()


# Q14 quadrupoles
# excdata_QDA()
# excdata_QDB1()
# excdata_QDB2()
# excdata_QDP1()
# excdata_QDP2()

# Q20 quadrupoles
# excdata_QFA()
# excdata_Q1()
# excdata_Q2()
# excdata_Q3()
# excdata_Q4()

# Q30 quadrupoles
# excdata_QFB()
excdata_QFP()
 

