function [val, out_options]=take_from_struct(options,fieldname,default)
%
% [OUT_OPTIONS, VAL] = TAKE_FROM_STRUCT(OPTIONS, FIELDNAME, DEFAULT)  
% 
% Take values from the options structure, use default if fiekd does
% not exist. Provide meaningful error messages. The function
% also updates the structure when the default is used.
% If default is not given, program aborts if field does not exist.
%
% Examples: 
% 
%  1. get the values of n_restarts, use default of 20 if field isnt set
%  [n_restarts, options] = take_from_struct(options, 'n_restarts', 20);
% 
%  2. get the values of n_restarts, abort if doesnt exist
%  [n_restarts, options] = take_from_struct(options, 'n_restarts');
%
% (C) GAl Chechik, 2004
% Software available for academic use. Other uses require explicit permission.
% 
  out_options = options;    
  try
    val = out_options.(fieldname);
  catch
    if(exist('default','var')==0)
      fprintf('\n\nError:\n');
      fprintf('    Field "%s" does not exist in structure\n\n', ...
	      fieldname);
      error('Trying to read from a field that does not exist');
    end    
    val=default;
    out_options.(fieldname) = val;
  end
