function [watermarkBits, watermarkImage] = generate_watermark(entropyVec)
    % GENERATE_WATERMARK: Creates binary watermark using PCA compression
    % Input: entropyVec - 1×1024 entropy vector
    % Output: watermarkBits - 1×50 binary watermark
    %         watermarkImage - 10×5 visualization
    
    % Center the data
    entropyVecCentered = entropyVec - mean(entropyVec);
    
    % Reshape for PCA: treat as multiple observations
    % Reshape 1024 values into 102 observations × 10 features
    % (This gives us a proper data matrix for PCA)
    numFeatures = 10;
    numObs = floor(length(entropyVecCentered) / numFeatures);
    
    % Trim to exact multiple
    trimmedVec = entropyVecCentered(1:numObs*numFeatures);
    entropyMatrix = reshape(trimmedVec, numObs, numFeatures);
    
    % Apply PCA
    [coeff, score, ~] = pca(entropyMatrix);
    
    % Use first 5 principal components
    numComponents = 5;
    pcaFeatures = score(:, 1:numComponents);  % 102×5 matrix
    
    % Flatten and take first 50 values for watermark
    pcaFlat = pcaFeatures(:)';  % 1×510
    pcaFeatures50 = pcaFlat(1:50);  % 1×50
    
    % Generate binary watermark (threshold at 0)
    watermarkBits = double(pcaFeatures50 > 0);  % 1×50 binary vector
    
    % Create visualization (10×5 image)
    watermarkImage = reshape(watermarkBits, [10, 5]);
    imwrite(watermarkImage, 'results/watermarkImage.png');
    
    disp(['  - PCA input matrix: ', num2str(size(entropyMatrix))]);
    disp(['  - Principal components used: ', num2str(numComponents)]);
    disp(['  - Watermark bits: ', num2str(length(watermarkBits))]);
    disp(['  - Watermark image size: ', num2str(size(watermarkImage))]);
end