function tango_print_error_stack_as_it_is(tango_error_stack)
%  TANGO_PRINT_ERROR_STACK_AS_IT_IS - Used to print the error stack in group
%
%  INPUTS
%  1. tango_error_stack
%
%
%  See example of use in gethbpmgroup

%  Adapted from N. Leclercq by Laurent S. Nadolski


% get the error stack
err_stack = tango_error_stack;
% display each DevError in the array
[err_stack_m, err_stack_n] = size(err_stack); 
stars(1:60) = char('*');
disp(stars);
disp('*                    TANGO ERROR STACK                     *')
disp(stars);
for i = 1:err_stack_n
  disp(sprintf('- ERROR %d\r', i));
  %- print reason
  disp(sprintf('\t|-reason.....%s\r',err_stack(1,i).reason));
  %- print desc
  disp(sprintf('\t|-desc.......%s\r',err_stack(1,i).desc));  
  %- print origin
  disp(sprintf('\t|-origin.....%s\r',err_stack(1,i).origin));
  %- print severity
  disp(sprintf('\t|-severity...%s (%d)\r',err_stack(1,i).severity_str, err_stack(1,i).severity));
end
disp(stars)
return;