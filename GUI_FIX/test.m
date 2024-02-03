function main()
    % Membuat GUI
    fig = uifigure('Name', 'Deteksi Penyakit Daun Kentang');
    grid = uigridlayout(fig, [2, 3]);

    % Axes untuk menampilkan citra
    axes1 = uiaxes(grid);
    axes2 = uiaxes(grid);
    axes3 = uiaxes(grid);
    axes4 = uiaxes(grid);

    % Button untuk memuat citra dan menampilkan di axes1
    button1 = uibutton(grid, 'Text', 'Muat Citra', 'ButtonPushedFcn', @(btn1, event) loadAndDisplayImage(axes1));

    % Button untuk resize citra dan menampilkan di axes2
    button2 = uibutton(grid, 'Text', 'Resize', 'ButtonPushedFcn', @(btn2, event) resizeAndDisplayImage(axes2));

    % Button untuk segmentasi K-Means dan menampilkan di axes3
    button3 = uibutton(grid, 'Text', 'Segmentasi K-Means', 'ButtonPushedFcn', @(btn3, event) kMeansSegmentation(axes3));

    % Button untuk ekstraksi fitur HSV
    button4 = uibutton(grid, 'Text', 'Ekstraksi Fitur HSV', 'ButtonPushedFcn', @(btn4, event) extractHSVFeatures());

    % Button untuk ekstraksi fitur tekstur LBP dan menampilkan di axes4
    button5 = uibutton(grid, 'Text', 'Fitur Tekstur LBP', 'ButtonPushedFcn', @(btn5, event) extractLBPFeatures(axes4));

    % Button untuk pelatihan model Random Forest
    button6 = uibutton(grid, 'Text', 'Pelatihan Model RF', 'ButtonPushedFcn', @(btn6, event) trainRandomForestModel());

    % Button untuk prediksi penyakit
    button7 = uibutton(grid, 'Text', 'Prediksi Penyakit', 'ButtonPushedFcn', @(btn7, event) predictDisease());

    % Fungsi untuk memuat citra dan menampilkannya di axes1
    function loadAndDisplayImage(axes)
        % Mendapatkan nama file citra
        [file, path] = uigetfile({'*.jpg;*.png', 'Image Files'}, 'Pilih Citra');
        if isequal(file, 0)
            return;
        end

        % Memuat citra
        img = imread(fullfile(path, file));

        % Menampilkan citra di axes
        imshow(img, 'Parent', axes);
        title(axes, 'Citra Asli');
    end

    % Fungsi untuk resize citra dan menampilkannya di axes2
    function resizeAndDisplayImage(axes)
        % Mendapatkan citra dari axes1
        img = get(axes1, 'Children').CData;

        % Resize citra
        img_resized = imresize(img, [150, 150]);

        % Menampilkan citra di axes
        imshow(img_resized, 'Parent', axes);
        title(axes, 'Citra Setelah Resize');
    end

    % Fungsi untuk segmentasi K-Means dan menampilkannya di axes3
    function kMeansSegmentation(axes)
        % Mendapatkan citra dari axes1
        img = get(axes1, 'Children').CData;

        % Melakukan segmentasi K-Means
        % Disini Anda perlu menulis kode untuk segmentasi K-Means sesuai dengan citra yang dimuat

        % Menampilkan hasil segmentasi di axes
        imshow(img, 'Parent', axes); % Ganti img dengan hasil segmentasi
        title(axes, 'Segmentasi K-Means (HSV)');
    end

    % Fungsi untuk ekstraksi fitur HSV
    function extractHSVFeatures()
        % Disini Anda perlu menulis kode untuk ekstraksi fitur HSV dari citra yang dimuat
        % Anda dapat menggunakan fungsi bawaan MATLAB seperti rgb2hsv untuk konversi ke ruang warna HSV
        % Kemudian, ekstraksi fitur seperti Mean, Standar Deviasi, dan skewness dari komponen H, S, dan V

        % Setelah diekstraksi, tampilkan hasil di uitable1
    end

    % Fungsi untuk ekstraksi fitur tekstur LBP dan menampilkannya di axes4
    function extractLBPFeatures(axes)
        % Mendapatkan citra dari axes1
        img = get(axes1, 'Children').CData;

        % Melakukan ekstraksi fitur tekstur LBP
        % Disini Anda perlu menulis kode untuk ekstraksi fitur tekstur LBP sesuai dengan citra yang dimuat

        % Menampilkan hasil ekstraksi di axes
        imshow(img, 'Parent', axes); % Ganti img dengan hasil ekstraksi LBP
        title(axes, 'Fitur Tekstur LBP');
    end

    % Fungsi untuk pelatihan model Random Forest
    function trainRandomForestModel()
        % Disini Anda perlu menulis kode untuk melatih model Random Forest
        % Gunakan fitctree atau fungsi lain dari Statistics and Machine Learning Toolbox

        % Setelah model dilatih, simpan model tersebut untuk digunakan pada prediksi
    end

    % Fungsi untuk prediksi penyakit
    function predictDisease()
        % Disini Anda perlu menulis kode untuk prediksi penyakit menggunakan model yang telah dilatih
        % Gunakan model Random Forest yang sudah dilatih sebelumnya

        % Tampilkan hasil prediksi
        % Pastikan untuk menampilkan hasil prediksi yang akurat
    end
end
