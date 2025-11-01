function entropyVec = entropy_extraction(photoFile)
    % ENTROPY_EXTRACTION: Extracts entropy features from a scene photo
    % Input: photoFile - path to input image
    % Output: entropyVec - 1×1024 vector of entropy values
    
    % Check if file exists
    if ~isfile(photoFile)
        error('Photo file not found: %s', photoFile);
    end
    
    % Read and preprocess image
    photo = imread(photoFile);
    
    % Convert to grayscale if RGB
    if size(photo, 3) == 3
        grayPhoto = rgb2gray(photo);
    else
        grayPhoto = photo;
    end
    
    % Resize to standard dimensions
    grayPhoto = imresize(grayPhoto, [256, 256]);
    
    % Calculate entropy for each 8×8 block
    blockSize = [8, 8];
    entropyMap = blockproc(grayPhoto, blockSize, @(blk) entropy(blk.data));
    
    % Save entropy map visualization
    imwrite(mat2gray(entropyMap), 'results/entropyMap.png');
    
    % Flatten to vector (32×32 blocks = 1024 values)
    entropyVec = entropyMap(:)';  % 1×1024 vector
    
    disp(['  - Entropy map size: ', num2str(size(entropyMap))]);
    disp(['  - Entropy vector length: ', num2str(length(entropyVec))]);
end