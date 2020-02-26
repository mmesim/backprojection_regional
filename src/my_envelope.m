function   env=my_envelope(y_cut)
%function to calculate normalized envelopes 

temp_trans=hilbert(y_cut);
temp_env=abs(temp_trans);

env=temp_env./max(temp_env);
   

end