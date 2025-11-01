clc; clear; close all;

% Create results folder if it doesn't exist
if ~exist('results', 'dir')
    mkdir('results');
end

disp('=== Entropy-Based Document Watermarking System ===');

% STEP 1: Extract entropy from photo
disp('Step 1: Extracting entropy from scene photo...');
entropyVec = entropy_extraction('scene_photo.jpg');
disp('✓ Entropy extraction complete');

% STEP 2: Generate watermark using PCA
disp('Step 2: Generating watermark using PCA...');
[watermarkBits, watermarkImage] = generate_watermark(entropyVec);
disp('✓ Watermark generation complete');

% Save reference watermark for testing
save('results/watermark_reference.mat', 'watermarkBits');

% STEP 3: Embed watermark into document using SVD
disp('Step 3: Embedding watermark into document...');
watermarkedDoc = embed_watermark('document.jpg', watermarkBits);
disp('✓ Watermark embedding complete');

% STEP 4: Verify authenticity by extracting watermark
disp('Step 4: Verifying document authenticity...');
verify_document(watermarkedDoc, watermarkBits);

disp('=== Process Completed Successfully ===');
disp('Check results folder for output files');