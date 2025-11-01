function test_random_document(testDocFile)
    % TEST_RANDOM_DOCUMENT: Test if a document is authentic or fake
    % Input: testDocFile - path to document to test
    %        (if empty, prompts user to select file)
    
    clc;
    fprintf('\n=== Document Authentication Test ===\n\n');
    
    % If no file specified, let user select
    if nargin < 1 || isempty(testDocFile)
        [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'}, ...
                                         'Select Document to Test');
        if filename == 0
            disp('No file selected. Exiting...');
            return;
        end
        testDocFile = fullfile(pathname, filename);
    end
    
    % Check if file exists
    if ~isfile(testDocFile)
        error('Test document not found: %s', testDocFile);
    end
    
    fprintf('Testing document: %s\n\n', testDocFile);
    
    % Check if watermarking system has been run (need reference data)
    if ~isfile('results/original_S_values.mat')
        error(['ERROR: No reference watermark found!\n' ...
               'You must first run the main watermarking system (main.m)\n' ...
               'to create a reference watermark before testing documents.']);
    end
    
    % Load reference watermark data
    load('results/original_S_values.mat', 'S_original', 'alpha');
    
    % Also need the original watermark bits for comparison
    if ~isfile('results/watermark_reference.mat')
        warning(['Warning: Original watermark bits not found.\n' ...
                'Running with limited verification capability.\n' ...
                'For full testing, save watermark in main.m']);
        origWatermark = [];
    else
        load('results/watermark_reference.mat', 'watermarkBits');
        origWatermark = watermarkBits;
    end
    
    % Read and preprocess test document
    fprintf('Step 1: Loading and preprocessing test document...\n');
    testDoc = imread(testDocFile);
    
    % Convert to grayscale if RGB
    if size(testDoc, 3) == 3
        testDocGray = rgb2gray(testDoc);
    else
        testDocGray = testDoc;
    end
    
    % Resize to match watermarking dimensions
    testDocGray = imresize(testDocGray, [256, 256]);
    fprintf('  ✓ Document preprocessed (256x256)\n\n');
    
    % Perform SVD on test document
    fprintf('Step 2: Extracting potential watermark...\n');
    [~, S_test, ~] = svd(double(testDocGray));
    
    % Extract potential watermark bits
    extractedBits = zeros(50, 1);
    extractedRaw = zeros(50, 1);
    
    for i = 1:50
        diff = S_test(i,i) - S_original(i,i);
        extractedRaw(i) = diff / alpha;
        extractedBits(i) = double(extractedRaw(i) > 0.3);
    end
    
    extractedWatermark = extractedBits';
    fprintf('  ✓ Watermark extracted\n\n');
    
    % Calculate statistics of extracted values
    meanRaw = mean(abs(extractedRaw));
    stdRaw = std(extractedRaw);
    maxRaw = max(abs(extractedRaw));
    
    % Analyze if document looks watermarked
    fprintf('Step 3: Analyzing watermark characteristics...\n');
    fprintf('  - Mean absolute value: %.4f\n', meanRaw);
    fprintf('  - Standard deviation: %.4f\n', stdRaw);
    fprintf('  - Maximum value: %.4f\n\n', maxRaw);
    
    % If we have original watermark, do full comparison
    if ~isempty(origWatermark)
        fprintf('Step 4: Comparing with reference watermark...\n');
        
        bitErrors = sum(extractedWatermark ~= origWatermark);
        bitAccuracy = (50 - bitErrors) / 50 * 100;
        
        % Correlation
        if std(extractedWatermark) == 0 || std(origWatermark) == 0
            correlation = double(all(extractedWatermark == origWatermark));
        else
            correlation = corr2(extractedWatermark, origWatermark);
        end
        
        directSimilarity = sum(extractedWatermark == origWatermark) / 50;
        
        % Decision logic
        threshold = 90;  % 90% accuracy threshold
        
        fprintf('\n========================================\n');
        fprintf('           VERIFICATION RESULTS\n');
        fprintf('========================================\n\n');
        
        if bitAccuracy >= threshold
            fprintf('  STATUS: ✓ AUTHENTIC DOCUMENT\n\n');
            fprintf('  This document contains the correct watermark!\n');
            fprintf('  It was created by your watermarking system.\n\n');
        else
            fprintf('  STATUS: ✗ FAKE/TAMPERED DOCUMENT\n\n');
            fprintf('  This document is either:\n');
            fprintf('   - Not watermarked by your system\n');
            fprintf('   - Has been tampered with\n');
            fprintf('   - Is a completely different document\n\n');
        end
        
        fprintf('  Metrics:\n');
        fprintf('  ├─ Bit Accuracy: %.2f%% (threshold: %.0f%%)\n', bitAccuracy, threshold);
        fprintf('  ├─ Bits Matched: %d/50 (Errors: %d)\n', sum(extractedWatermark == origWatermark), bitErrors);
        fprintf('  ├─ Correlation: %.4f\n', correlation);
        fprintf('  └─ Direct Similarity: %.4f\n\n', directSimilarity);
        
        fprintf('========================================\n\n');
        
        % Show first 10 bits for debugging
        fprintf('Debug Info - First 10 bits:\n');
        fprintf('  Reference:  ');
        fprintf('%d ', origWatermark(1:10));
        fprintf('\n');
        fprintf('  Extracted:  ');
        fprintf('%d ', extractedWatermark(1:10));
        fprintf('\n');
        fprintf('  Raw values: ');
        fprintf('%.2f ', extractedRaw(1:10));
        fprintf('\n\n');
        
    else
        % No reference watermark - use heuristics
        fprintf('Step 4: Heuristic analysis (no reference available)...\n\n');
        
        fprintf('========================================\n');
        fprintf('           HEURISTIC RESULTS\n');
        fprintf('========================================\n\n');
        
        % Heuristic: If mean value is close to 0 and max is small, likely not watermarked
        if meanRaw < 0.1 && maxRaw < 0.5
            fprintf('  STATUS: ✗ LIKELY NOT WATERMARKED\n\n');
            fprintf('  The extracted values are too small.\n');
            fprintf('  This document probably does not contain a watermark.\n\n');
        elseif meanRaw > 0.3 || maxRaw > 2.0
            fprintf('  STATUS: ? POSSIBLY WATERMARKED\n\n');
            fprintf('  Some watermark-like patterns detected, but\n');
            fprintf('  cannot verify without reference watermark.\n\n');
        else
            fprintf('  STATUS: ? UNCERTAIN\n\n');
            fprintf('  Inconclusive. Need reference watermark for verification.\n\n');
        end
        
        fprintf('  Note: For accurate verification, run main.m first\n');
        fprintf('        to establish a reference watermark.\n\n');
        fprintf('========================================\n\n');
    end
    
    % Save visualization
    figure('Visible', 'off', 'Position', [100, 100, 1200, 400]);
    
    subplot(1,3,1);
    imshow(testDocGray, []);
    title('Test Document');
    
    subplot(1,3,2);
    extractedImage = reshape(extractedBits, [10, 5]);
    imshow(extractedImage, []);
    title('Extracted Watermark');
    
    subplot(1,3,3);
    bar(extractedRaw);
    title('Raw Extracted Values');
    xlabel('Bit Index');
    ylabel('Value');
    grid on;
    
    saveas(gcf, 'results/test_results.png');
    close;
    
    fprintf('Results saved to: results/test_results.png\n\n');
end