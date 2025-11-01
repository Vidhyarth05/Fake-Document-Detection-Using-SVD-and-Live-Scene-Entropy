# 🔒 Fake Document Detection Using SVD and Live Scene Entropy

## 🌟 Project Overview

This project presents an innovative and robust method for **digital document authentication** by leveraging **Singular Value Decomposition (SVD)** and **live scene entropy**. The system creates a unique, non-reproducible digital signature (watermark) from the randomness of a real-time scene and embeds it into a document's SVD domain, making the document authentic only within the context of its creation. This approach provides high assurance against forgery and unauthorized copying.

### Key Concepts

- **Dynamic Watermark:** The watermark is generated from the Shannon entropy of a scene photograph, ensuring each document is signed with a unique, time-specific, one-time digital signature
- **SVD Robustness:** Singular Value Decomposition (SVD) is used for embedding, as it modifies the document's spectral properties without noticeable visual distortion, providing mathematical reliability
- **PCA Compression:** Principal Component Analysis (PCA) is applied to the high-dimensional entropy data to create a compact, 50-bit binary watermark, ensuring computational efficiency
- **Authentication:** Verification is achieved by comparing the extracted watermark's Bit Accuracy against a **90% threshold**

---

## ⚙️ System Workflow (The Four Stages)

The entire authentication process is modularized and orchestrated by the `main.m` script.

| Stage | Function | Description |
|:------|:---------|:------------|
| **1. Entropy Extraction** | `entropy_extraction.m` | Calculates the Shannon entropy for 8×8 blocks of a 256×256 grayscale scene image, resulting in a 1×1024 vector |
| **2. Watermark Generation** | `generate_watermark.m` | Uses PCA to compress the 1×1024 entropy vector, extracts the first 50 components, and converts them to a **1×50 binary watermark** |
| **3. Watermark Embedding** | `embed_watermark.m` | Performs SVD on the document D = USVᵀ and modifies the first 50 singular values using additive modulation: σ̃ᵢ = σᵢ + α·wᵢ. The **Original S values are saved** for verification |
| **4. Authenticity Verification** | `verify_document.m` | Extracts the watermark by calculating the difference between the test document's singular values (Sₜ) and the saved original ones (S_original) |

---

## 🚀 Getting Started

### Prerequisites

- **MATLAB** with the Image Processing Toolbox and Statistics and Machine Learning Toolbox
- A base document image (`document.jpg`) and a live scene image (`scene_photo.jpg`)

### Setup Instructions

1. **Clone the Repository**
   ```bash
   git clone [repository-url]
   cd [repository-name]
   ```

2. **Prepare Input Files**
   - **Save your target document image** (e.g., a certificate or ID) as **`document.jpg`** in the project root
   - **Save a live scene image** (a photo of your current environment) as **`scene_photo.jpg`** in the project root

3. **Run the Main Script**
   - Open MATLAB and navigate to the project directory
   - Run the main execution script:
     ```matlab
     >> main
     ```

### Testing and Verification

After running `main.m`, use the provided utility scripts to test documents.

| Script | Purpose |
|:-------|:--------|
| `quick_test.m` | Runs a simple test and prompts you to select a document to test against the established reference watermark |
| `test_random_document(test_file)` | Function to programmatically test any document image file |

**Expected Output:** The system will output a status of **`AUTHENTIC`** (if Bit Accuracy ≥ 90%) or **`FAKE/TAMPERED`**. All detailed results, visualizations, and reference data are saved in the automatically created `/results` folder.

---

## 📊 Technical Details

### Watermark Embedding Process

The embedding strength parameter α controls the trade-off between robustness and imperceptibility. The modified singular values are reconstructed to create the watermarked document while preserving visual quality.

### Security Features

- **One-Time Signature:** Each watermark is unique to the specific scene captured at the time of document creation
- **Tamper Detection:** Any modification to the document significantly affects the singular values, resulting in low bit accuracy during verification
- **Non-Transferable:** The watermark cannot be extracted and reused for other documents due to its integration with the document's spectral properties

---

## 📁 Project Structure

```
├── main.m                      # Main orchestration script
├── entropy_extraction.m        # Stage 1: Entropy calculation
├── generate_watermark.m        # Stage 2: PCA-based watermark generation
├── embed_watermark.m           # Stage 3: SVD embedding
├── verify_document.m           # Stage 4: Authentication verification
├── quick_test.m                # Quick testing utility
├── test_random_document.m      # Programmatic testing function
├── document.jpg                # Input: Base document image
├── scene_photo.jpg             # Input: Live scene photograph
└── results/                    # Output: Results and visualizations
```

---

## 🔬 How It Works

1. **Capture Randomness:** A live scene photo captures environmental entropy that cannot be replicated
2. **Generate Signature:** Shannon entropy is calculated across image blocks and compressed via PCA
3. **Embed Watermark:** The binary watermark modifies the document's singular values imperceptibly
4. **Verify Authenticity:** Extraction and comparison determine if the document is authentic or tampered

---

## 🎯 Use Cases

- Digital certificate authentication
- Secure document signing
- Anti-counterfeiting for official documents
- Forensic document verification
- Timestamped document validation

---

## 📝 License

[Add your license information here]

## 🤝 Contributing

[Add contribution guidelines here]

## 📧 Contact

[Add contact information here]