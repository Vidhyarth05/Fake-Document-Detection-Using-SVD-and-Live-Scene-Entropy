# 🔒 Fake Document Detection Using SVD and Live Scene Entropy

## 🌟 Project Overview

This project presents an innovative and robust method for **digital document authentication** by leveraging **Singular Value Decomposition (SVD)** and **live scene entropy**. [cite_start]The system creates a unique, non-reproducible digital signature (watermark) from the randomness of a real-time scene and embeds it into a document's SVD domain, making the document authentic only within the context of its creation[cite: 14, 15]. [cite_start]This approach provides high assurance against forgery and unauthorized copying[cite: 16, 17].

### Key Concepts

* [cite_start]**Dynamic Watermark:** The watermark is generated from the Shannon entropy of a scene photograph, ensuring each document is signed with a unique, time-specific, one-time digital signature[cite: 15, 27, 53].
* [cite_start]**SVD Robustness:** Singular Value Decomposition (SVD) is used for embedding, as it modifies the document's spectral properties without noticeable visual distortion, providing mathematical reliability[cite: 16, 24, 102].
* [cite_start]**PCA Compression:** Principal Component Analysis (PCA) is applied to the high-dimensional entropy data to create a compact, 50-bit binary watermark, ensuring computational efficiency[cite: 73, 74].
* [cite_start]**Authentication:** Verification is achieved by comparing the extracted watermark's Bit Accuracy against a **90% threshold**[cite: 154].

---

## ⚙️ System Workflow (The Four Stages)

The entire authentication process is modularized and orchestrated by the `main.m` script.

| Stage | Function | Description |
| :--- | :--- | :--- |
| **1. Entropy Extraction** | `entropy_extraction.m` | [cite_start]Calculates the Shannon entropy for $8 \times 8$ blocks of a $256 \times 256$ grayscale scene image, resulting in a $1 \times 1024$ vector[cite: 66, 71]. |
| **2. Watermark Generation** | `generate_watermark.m` | [cite_start]Uses PCA to compress the $1 \times 1024$ entropy vector, extracts the first 50 components, and converts them to a **$1 \times 50$ binary watermark**[cite: 73, 91, 95]. |
| **3. Watermark Embedding** | `embed_watermark.m` | [cite_start]Performs SVD on the document $D = USV^T$ and modifies the first 50 singular values using additive modulation: $\tilde{\sigma}_{i}=\sigma_{i}+\alpha\cdot w_{i}$[cite: 105, 111]. [cite_start]The **Original $S$ values are saved** for verification[cite: 108, 122]. |
| **4. Authenticity Verification** | `verify_document.m` | [cite_start]Extracts the watermark by calculating the difference between the test document's singular values ($S_t$) and the saved original ones ($S_{original}$)[cite: 126, 127]. |

---

## 🚀 Getting Started

### Prerequisites
* [cite_start]**MATLAB** with the Image Processing Toolbox and Statistics and Machine Learning Toolbox[cite: 157].
* A base document image (`document.jpg`) and a live scene image (`scene_photo.jpg`).

### Setup Instructions

1.  **Clone the Repository**
    ```bash
    git clone [repository-url]
    cd [repository-name]
    ```

2.  **Prepare Input Files**
    * **Save your target document image** (e.g., a certificate or ID) as **`document.jpg`** in the project root.
    * **Save a live scene image** (a photo of your current environment) as **`scene_photo.jpg`** in the project root.

3.  **Run the Main Script**
    * Open MATLAB and navigate to the project directory.
    * Run the main execution script:
        ```matlab
        >> main
        ```

### Testing and Verification

After running `main.m`, use the provided utility scripts to test documents.

| Script | Purpose |
| :--- | :--- |
| `quick_test.m` | Runs a simple test and prompts you to select a document to test against the established reference watermark. |
| `test_random_document(test_file)` | Function to programmatically test any document image file. |

[cite_start]**Expected Output:** The system will output a status of **`AUTHENTIC`** (if Bit Accuracy $\ge 90\%$) or **`FAKE/TAMPERED`**[cite: 151, 152]. [cite_start]All detailed results, visualizations, and reference data are saved in the automatically created `/results` folder[cite: 158, 159].