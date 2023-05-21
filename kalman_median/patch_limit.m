function [p1, p2] = patch_limit(Img_resap, natur_light, C0, C1, frame)

if length(natur_light) == 1
    natur_light = natur_light * ones(3, 1);
end
if length(C0) == 1
    C0 = C0 * ones(3, 1);
end
if length(C1) == 1
    C1 = C1 * ones(3, 1);
end
Img_resap = double(Img_resap);

% pixel-wise boundary
t_r = max((natur_light(1) - Img_resap(:, :, 1)) ./ (natur_light(1)  -  C0(1)), (Img_resap(:, :, 1) - natur_light(1)) ./ (C1(1) - natur_light(1) ));
t_g = max((natur_light(2) - Img_resap(:, :, 2)) ./ (natur_light(2)  - C0(2)), (Img_resap(:, :, 2) - natur_light(2)) ./ (C1(2) - natur_light(2) ));
p2 = max((natur_light(3) - Img_resap(:, :, 3)) ./ (natur_light(3)  - C0(3)), (Img_resap(:, :, 3) - natur_light(3)) ./ (C1(3) - natur_light(3) ));
p2 = max(cat(3, t_r, t_g, p2), [], 3);
p2 = min(p2, 1);

% minimum filtering
se = strel('square', frame);
p1 = imclose(p2, se);
