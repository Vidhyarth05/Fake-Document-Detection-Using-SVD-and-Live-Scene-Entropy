% QUICK_TEST: Quick way to test any document
% Just run this script and select a document to test

clc;

fprintf('\n╔════════════════════════════════════════════════╗\n');
fprintf('║     QUICK DOCUMENT AUTHENTICATION TEST        ║\n');
fprintf('╚════════════════════════════════════════════════╝\n\n');

fprintf('This will test if a document is authentic or fake.\n');
fprintf('Please select a document to test...\n\n');

% Prompt user to select document
test_random_document();

fprintf('\n╔════════════════════════════════════════════════╗\n');
fprintf('║              TEST COMPLETE                     ║\n');
fprintf('╚════════════════════════════════════════════════╝\n\n');

fprintf('To test another document, run this script again or use:\n');
fprintf('  >> test_random_document(''your_document.jpg'')\n\n');