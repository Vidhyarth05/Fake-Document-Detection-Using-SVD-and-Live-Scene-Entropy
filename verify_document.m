function verify_document(watermarkedDoc, origWatermark)
    % VERIFY_DOCUMENT: Verifies document authenticity by extracting watermark
    % Input: watermarkedDoc - watermarked document image
    %        origWatermark - original 1×50 watermark bits
    
    % Load ORIGINAL S values and alpha (before embedding)
    if ~isfile('results/original_S_values.mat')
        error('Original S values not found. Run embed_watermark first.');
    end
    load('results/original_S_values.mat', 'S_original', 'alpha');
    
    % Perform SVD on watermarked document
    [~, S_watermarked, ~] = svd(double(watermarkedDoc));
    
    % Extract watermark bits with improved method
    extractedBits = zeros(50, 1);
    extractedRaw = zeros(50, 1);  % Store raw extracted values
    
    for i = 1:50
        % Calculate difference between watermarked and original
        diff = S_watermarked(i,i) - S_original(i,i);
        % Recover raw value
        extractedRaw(i) = diff / alpha;
        % Threshold to binary with adaptive threshold (0.3 instead of 0.5)
        % This accounts for reconstruction errors
        extractedBits(i) = double(extractedRaw(i) > 0.3);
    end
    
    % Reshape for comparison
    extractedWatermark = extractedBits';  % 1×50
    
    % Calculate similarity metrics
    % Method 1: Bit Error Rate (BER)
    bitErrors = sum(extractedWatermark ~= origWatermark);
    bitAccuracy = (50 - bitErrors) / 50 * 100;
    
    % Method 2: Normalized Cross-Correlation (handle NaN)
    if std(extractedWatermark) == 0 || std(origWatermark) == 0
        similarity = double(all(extractedWatermark == origWatermark));
    else
        similarity = corr2(extractedWatermark, origWatermark);
    end
    
    % Method 3: Direct similarity score
    directSimilarity = sum(extractedWatermark == origWatermark) / 50;
    
    % Determine authenticity using bit accuracy (more reliable)
    threshold = 90;  % 90% bit accuracy threshold (45/50 bits)
    if bitAccuracy >= threshold
        status = 'AUTHENTIC';
        symbol = '✓';
    else
        status = 'FAKE/TAMPERED';
        symbol = '✗';
    end
    
    % Display results
    fprintf('\n--- Verification Results ---\n');
    fprintf('Status: %s %s\n', status, symbol);
    fprintf('Bit Accuracy: %.2f%% (threshold: %.0f%%)\n', bitAccuracy, threshold);
    fprintf('Bits Matched: %d/%d (Errors: %d)\n', sum(extractedWatermark == origWatermark), 50, bitErrors);
    fprintf('Correlation: %.4f\n', similarity);
    fprintf('Direct Similarity: %.4f\n', directSimilarity);
    fprintf('---------------------------\n\n');
    
    % Display first 10 bits for debugging
    fprintf('Debug - First 10 bits comparison:\n');
    fprintf('Original:  ');
    fprintf('%d ', origWatermark(1:10));
    fprintf('\n');
    fprintf('Extracted: ');
    fprintf('%d ', extractedWatermark(1:10));
    fprintf('\n');
    fprintf('Raw values: ');
    fprintf('%.2f ', extractedRaw(1:10));
    fprintf('\n\n');
    
    % Save detailed report
    reportFile = 'results/verification_report.txt';
    fid = fopen(reportFile, 'w');
    fprintf(fid, '=== Document Verification Report ===\n\n');
    fprintf(fid, 'Status: %s %s\n\n', status, symbol);
    fprintf(fid, 'Metrics:\n');
    fprintf(fid, '  Bit Accuracy: %.2f%%\n', bitAccuracy);
    fprintf(fid, '  Bits Matched: %d/%d\n', sum(extractedWatermark == origWatermark), 50);
    fprintf(fid, '  Bit Errors: %d\n', bitErrors);
    fprintf(fid, '  Correlation: %.4f\n', similarity);
    fprintf(fid, '  Direct Similarity: %.4f\n\n', directSimilarity);
    fprintf(fid, 'Parameters:\n');
    fprintf(fid, '  Threshold: %.0f%% bit accuracy\n', threshold);
    fprintf(fid, '  Alpha: %.3f\n\n', alpha);
    fprintf(fid, 'Timestamp: %s\n', datestr(now));
    fclose(fid);
    
    % Save extracted watermark visualization
    extractedImage = reshape(extractedBits, [10, 5]);
    imwrite(mat2gray(extractedImage), 'results/extracted_watermark.png');
    
    % Save comparison visualization
    figure('Visible', 'off');
    subplot(1,3,1);
    imshow(reshape(origWatermark, [10, 5]), []);
    title('Original Watermark');
    subplot(1,3,2);
    imshow(extractedImage, []);
    title('Extracted Watermark');
    subplot(1,3,3);
    imshow(abs(reshape(origWatermark, [10, 5]) - extractedImage), []);
    title('Difference');
    saveas(gcf, 'results/watermark_comparison.png');
    close;
end