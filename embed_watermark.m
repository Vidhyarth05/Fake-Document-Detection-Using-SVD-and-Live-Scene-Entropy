function watermarkedDoc = embed_watermark(docFile, watermarkBits)
    % EMBED_WATERMARK: Embeds watermark into document using SVD
    % Input: docFile - path to document image
    %        watermarkBits - 1×50 binary watermark
    % Output: watermarkedDoc - watermarked document image
    
    % Check if file exists
    if ~isfile(docFile)
        error('Document file not found: %s', docFile);
    end
    
    % Read and preprocess document
    doc = imread(docFile);
    
    % Convert to grayscale if RGB
    if size(doc, 3) == 3
        docGray = rgb2gray(doc);
    else
        docGray = doc;
    end
    
    % Resize to standard dimensions
    docGray = imresize(docGray, [256, 256]);
    docGray = double(docGray);
    
    % Perform SVD on original document
    [U, S, V] = svd(docGray);
    
    % IMPORTANT: Save ORIGINAL S matrix before modification
    S_original = S;
    
    % Embedding strength parameter (increased for better detectability)
    alpha = 10.0;  % Increased from 0.05 for stronger embedding
    
    % Convert watermark to column vector
    W = watermarkBits(:);  % 50×1
    
    % Verify watermark is binary
    if ~all(ismember(W, [0, 1]))
        error('Watermark must contain only 0s and 1s');
    end
    
    % Embed watermark into singular values
    % Using additive embedding: S_new = S + alpha * W
    S_modified = S;
    for i = 1:length(W)
        S_modified(i,i) = S(i,i) + alpha * W(i);
    end
    
    % Reconstruct watermarked document
    watermarkedDoc = uint8(U * S_modified * V');
    
    % Save watermarked document
    imwrite(watermarkedDoc, 'results/watermarked_document.png');
    
    % Save ORIGINAL S values and alpha for verification
    save('results/original_S_values.mat', 'S_original', 'alpha');
    
    % Calculate and display embedding statistics
    avgChange = mean(abs(S_modified(1:50, 1:50) - S_original(1:50, 1:50)), 'all');
    maxChange = max(abs(S_modified(1:50, 1:50) - S_original(1:50, 1:50)), [], 'all');
    
    disp(['  - Document size: ', num2str(size(docGray))]);
    disp(['  - Watermark bits embedded: ', num2str(length(W))]);
    disp(['  - Embedding strength (alpha): ', num2str(alpha)]);
    disp(['  - Average singular value change: ', num2str(avgChange, '%.4f')]);
    disp(['  - Maximum singular value change: ', num2str(maxChange, '%.4f')]);
    
    % Display watermark statistics
    fprintf('  - Watermark: %d ones, %d zeros\n', sum(W), sum(W==0));
end