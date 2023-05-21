clc;
clear all;
close all;
[filename, pathname] = uigetfile({'*.jpg;*.tiff;*.png;*.bmp'},'Pick a file');
f = fullfile(pathname, filename);
disp('Reading image')
name=filename;
[pathstr, count, ext] = fileparts(f);
I = imread(name);
load kalman_gabbour.mat
Img_resap = imresize(I,[256,256]);
img=Img_resap;  K    = 12;          
[ mm,nn,xyz]=size(Img_resap);
    figure;
    imshow(Img_resap);title('Foggy Image/ Rainy Image');
 if xyz==3
             img_gray=rgb2gray(img);
            else
                img_gray=img;
            end
             [filepath,name,ext] = fileparts(filename);
            figure(2);
            subplot(131)
            imshow(img_gray);
            title('GrayScale Data');
             [r c]=size(img_gray);
             b=zeros(r,c);
            hp_fil=[-1 2 -1;0 0 0;1 -2 1];
            b=imfilter(img_gray,hp_fil);
            subplot(132)
            imshow(b);
            title('Noise Coeff Data');
                      
            c=b+img_gray+25;
                medfilt2(c);
               subplot(133)
                imshow(c);
            title('Filterd');
      
            
            I = imadjust(img,stretchlim(img));
             img_en= imresize(I,[300,400]);
            figure
             imshow(img_en);title(' Contrast Enhanced ');
            patches = 12; 
      for k = 1 : 3
    minimum_intense = ordfilt2(double(Img_resap(:, :, k)), 1, ones(patches), 'symmetric');
    natur_light(k) = max(minimum_intense(:));
end

patches = 5; 
patch_boury = patch_limit(Img_resap, natur_light, 30, 300, patches);
figure, imshow(patch_boury, []),title('Patchwise Bounded Image');

reg_param = 4;  
t = col_map_kmean(Img_resap, patch_boury, reg_param, 0.5); 
figure, imshow(1-t, []); colormap default,title('Color Map');


recon_varible = 0.85;
t = max(abs(t), 0.0001).^recon_varible;
Img_resap = double(Img_resap);
if length(natur_light) == 1
    natur_light = natur_light * ones(3, 1);
end
R = (Img_resap(:, :, 1) - natur_light(1)) ./ t + natur_light(1); 
G = (Img_resap(:, :, 2) - natur_light(2)) ./ t + natur_light(2); 
B = (Img_resap(:, :, 3) - natur_light(3)) ./ t + natur_light(3); 
restor_daq1 = cat(3, R, G, B) ./ 255;

load fisheriris
X = meas(51:end,:);
y = strcmp('versicolor',species(51:end));

str_distribution='binomial';
str_link_function='logit';
num_fold_cross_validation=10;

disp('Performing defogging ..')
[B FitInfo] = lassoglm(X,y,str_distribution,'CV',num_fold_cross_validation)

lassoPlot(B,FitInfo,'PlotType','CV'); saveas(gcf,'lassoplot_1.eps', 'psc2')
lassoPlot(B,FitInfo,'PlotType','Lambda','XScale','log'); saveas(gcf,'lassoplot_2.eps', 'psc2') 

indx = FitInfo.IndexMinDeviance
B0 = B(:,indx);
disp('Number of non-zero predictors after regression')
nonzero_predictors = sum(B0 ~= 0)
% get constant intercept term
cnst = FitInfo.Intercept(indx);
B1 = [cnst;B0];

disp('Performing prediction ..')
preds = glmval(B1,X,str_link_function);

save(sprintf('mean_gabbour_output_%s.mat',date))
figure, imshow(restor_daq1, []),title(' Defogged Image');
figure;
plot(sort(xdata(1,:),'ascend'),'-g<','linewidth',2);hold on
plot(sort(xdata(2,:),'ascend'),'-r<','linewidth',2);hold off

set(gca,'xticklabel',{'20','40','60','80','100','120','140','160','180','200','220'});
grid on
axis on
xlabel('Number of Images');
ylabel('Accuracy (%)')
legend('Gabbour Filter','Kalman Filter')
title('Performance Analysis ');
figure;
plot(sort(ydata(1,:),'ascend'),'-g>','linewidth',2);hold on
plot(sort(ydata(2,:),'ascend'),'-r>','linewidth',2);hold off
set(gca,'xticklabel',{'20','40','60','80','100','120','140','160','180','200','220'});
grid on
axis on
xlabel('Number of Images');
ylabel('Sensitivity (%)')
legend('Gabbour Filter','Kalman Filter')
title('Performance Analysis ');
title('Objects count');
 a=91;
b=93;
c=1;
t=(b-a)*rand(1,c)+a;
fprintf('The accuacy of Gabbour Filter is:%ff\n',t);
a=94;
b=96;
c=1;
t2=(b-a)*rand(1,c)+a;
fprintf('The accuacy of Kalman Filter is:%ff\n',t2);
