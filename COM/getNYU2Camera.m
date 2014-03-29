function C = getNYU2Camera()
% RGB Intrinsic Parameters
  fx_rgb = 5.1885790117450188e+02;
  fy_rgb = 5.1946961112127485e+02;
  cx_rgb = 3.2558244941119034e+02;
  cy_rgb = 2.5373616633400465e+02;
  fc_rgb = [fx_rgb,fy_rgb];
  cc_rgb = [cx_rgb,cy_rgb];
  C = [fc_rgb(1) 0 cc_rgb(1);
    0 fc_rgb(2) cc_rgb(2);
    0 0 1];
end
