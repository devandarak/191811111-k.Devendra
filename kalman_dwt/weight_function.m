function Weight = weight_function(fogged, D, val)
fogged = double(fogged) / 255;
d_r = imfilter(fogged(:, :, 1), D, 'circular');
d_g = imfilter(fogged(:, :, 2), D, 'circular');
d_b = imfilter(fogged(:, :, 3), D, 'circular');
Weight = exp(-(d_r.^2 + d_g.^2 + d_b.^2) / val / 2);