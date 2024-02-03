function varargout = guimatlab(varargin)
% GUIMATLAB MATLAB code for guimatlab.fig
%      GUIMATLAB, by itself, creates a new GUIMATLAB or raises the existing
%      singleton*.
%
%      H = GUIMATLAB returns the handle to a new GUIMATLAB or the handle to
%      the existing singleton*.
%
%      GUIMATLAB('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIMATLAB.M with the given input arguments.
%
%      GUIMATLAB('Property','Value',...) creates a new GUIMATLAB or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guimatlab_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guimatlab_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guimatlab

% Last Modified by GUIDE v2.5 02-Feb-2024 21:34:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guimatlab_OpeningFcn, ...
                   'gui_OutputFcn',  @guimatlab_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before guimatlab is made visible.
function guimatlab_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guimatlab (see VARARGIN)

% Choose default command line output for guimatlab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guimatlab wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guimatlab_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               INPUT CITRA
function pushbutton1_Callback(hObject, ~, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.*', 'Pilih gambar daun');
if isequal(filename, 0)
    return;
end

% Memuat citra daun
image_path = fullfile(pathname, filename);
leaf_image = imread(image_path);

% Menampilkan citra pada axes1
axes(handles.axes1);
imshow(leaf_image);
title('Citra Asli');

% Menyimpan citra pada handles
handles.original_image = leaf_image;
guidata(hObject, handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               RESET CITRA DI AXES 1
function pushbutton2_Callback(hObject, ~, handles)
    % Menghapus citra dari axes1, axes2, axes3, dan axes4
    axes(handles.axes1);
    cla; % Membersihkan isi axes1
    axes(handles.axes2);
    cla; % Membersihkan isi axes2
    axes(handles.axes3);
    cla; % Membersihkan isi axes3
    axes(handles.axes4);
    cla; % Membersihkan isi axes4

    % Menghapus data citra dari handles
    if isfield(handles, 'original_image')
        handles = rmfield(handles, 'original_image');
    end

    % Menghapus data dari uitable1
    data = cell(3, 3); % Membuat sel kosong 3x3
    set(handles.uitable1, 'Data', data);

    % Menyimpan handles kembali ke guidata
    guidata(hObject, handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               RESIZE CITRA
function pushbutton3_Callback(hObject, ~, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Mendapatkan citra asli dari handles
leaf_image = handles.original_image;

% Resize citra menjadi 150 x 150
resized_image = imresize(leaf_image, [150, 150]);

% Menampilkan citra yang telah diresize di axes2
axes(handles.axes2);
imshow(resized_image);
title('Citra 150x150');

% Menyimpan citra yang telah diresize pada handles
handles.resized_image = resized_image;
handles.is_resized = true; % Tambahkan penanda bahwa citra telah diresize
guidata(hObject, handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               K MEANS CLUSTERING & HASIL SEGMENTASI
function pushbutton4_Callback(hObject, ~, handles)
% Mengambil citra yang telah diresize
resized_image = handles.resized_image;

% Menyimpan citra yang telah diresize pada handles
handles.is_resized = true; % Tambahkan penanda bahwa citra telah diresize
guidata(hObject, handles);

% Panggil fungsi kmeans_clustering untuk melakukan segmentasi dan clustering KMeans
kmeans_clustering(handles);

function kmeans_clustering(handles)
    % Pastikan citra telah direzise sebelum melakukan clustering
    if ~isfield(handles, 'is_resized') || ~handles.is_resized
        msgbox('Mohon resize citra terlebih dahulu.', 'Error', 'error');
        return;
    end

    % Mendapatkan citra yang telah direzise
    resized_image = handles.resized_image;

    % Konversi citra ke ruang warna HSV
    HSV = rgb2hsv(resized_image);

    % Mengambil komponen HSV yang diproses
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    V = HSV(:,:,3);

    % Menyusun data untuk clustering
    data = [H(:), S(:), V(:)];

    % Lakukan KMeans clustering dengan jumlah klaster tertentu (misalnya, 3 klaster)
    num_clusters = 3;
    [idx, ~] = kmeans(data, num_clusters);

    % Mengembalikan data ke bentuk citra
    segmented_image = reshape(idx, size(H)); % Perbaikan disini

    % Menampilkan citra hasil segmentasi di axes3
    axes(handles.axes3);
    imshow(segmented_image, []);
    colormap(gca, parula(num_clusters));
    colorbar;
    title('Hasil Segmentasi dengan KMeans (HSV)');

    % Menyimpan citra hasil segmentasi pada handles
    handles.segmented_image = segmented_image;
    guidata(handles.figure1, handles); % Menggunakan handles.figure1 untuk menyimpan data handles

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%               FITUR WARNA HASIL HSV
function pushbutton5_Callback(~, ~, handles)
% Pastikan citra telah direzise sebelum melakukan proses
    if ~isfield(handles, 'is_resized') || ~handles.is_resized
        msgbox('Mohon resize citra terlebih dahulu.', 'Error', 'error');
        return;
    end

    % Mendapatkan citra yang telah direzise
    resized_image = handles.resized_image;

    % Konversi citra ke ruang warna HSV
    HSV = rgb2hsv(resized_image);

    % Mendapatkan komponen HSV yang diproses
    H = HSV(:,:,1);
    S = HSV(:,:,2);
    V = HSV(:,:,3);

    % Hitung nilai mean, standar deviasi, dan skewness untuk setiap komponen warna
    H_mean = mean(H(:));
    H_std = std(H(:));
    H_skew = skewness(H(:));

    S_mean = mean(S(:));
    S_std = std(S(:));
    S_skew = skewness(S(:));

    V_mean = mean(V(:));
    V_std = std(V(:));
    V_skew = skewness(V(:));

    % Mendapatkan data saat ini dari uitable1
    current_data = get(handles.uitable1, 'Data');

    % Menambahkan nilai-nilai baru ke dalam data saat ini
    updated_data = { H_mean, H_std, H_skew; 
                     S_mean, S_std, S_skew; 
                     V_mean, V_std, V_skew};

    % Menampilkan hasil dalam sebuah tabel di GUI
    set(handles.uitable1, 'Data', updated_data);

% --- Executes during object creation, after setting all properties.
function uitable1_CreateFcn(~, ~, ~)
% hObject    handle to uitable1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: hObject stays empty until after calling the constructor

% Tambahkan kode di sini untuk menyesuaikan properti objek uitable

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   FITUR TEKSTUR LBP
function pushbutton6_Callback(hObject, ~, handles)
    % Pastikan citra telah direzise sebelum melakukan proses
    if ~isfield(handles, 'is_resized') || ~handles.is_resized
        msgbox('Mohon resize citra terlebih dahulu.', 'Error', 'error');
        return;
    end

    % Mendapatkan citra yang telah direzise
    resized_image = handles.resized_image;

    % Hitung LBP untuk setiap piksel dalam citra
    lbp_image = myExtractLBPFeatures(resized_image);

    % Hitung histogram LBP untuk mendapatkan fitur tekstur
    lbp_hist = histcounts(lbp_image, 'BinMethod', 'integers', 'Normalization', 'probability', 'BinLimits', [0, 255]);

    % Tampilkan histogram LBP atau fitur tekstur dalam bentuk grafik atau tabel di GUI Anda
    axes(handles.axes4);
    bar(lbp_hist);
    title('Histogram LBP');
    xlabel('Nilai LBP');
    ylabel('Frekuensi');

    % Simpan fitur tekstur dalam handles jika diperlukan untuk penggunaan selanjutnya
    handles.lbp_features = lbp_hist;
    guidata(hObject, handles);


function lbp_image = myExtractLBPFeatures(image)
    % Konversi citra ke dalam skala abu-abu jika belum dalam skala abu-abu
    if size(image, 3) == 3
        gray_image = rgb2gray(image);
    else
        gray_image = image;
    end

    % Inisialisasi matriks LBP dengan ukuran yang sama dengan citra
    [height, width] = size(gray_image);
    lbp_image = zeros(height, width);

    % Looping untuk setiap piksel dalam citra kecuali pinggiran
    for i = 2:height-1
        for j = 2:width-1
            % Hitung nilai LBP untuk piksel saat ini
            center_pixel = gray_image(i, j);
            binary_pattern = zeros(1, 8);
            binary_pattern(1) = gray_image(i-1, j-1) >= center_pixel;
            binary_pattern(2) = gray_image(i-1, j) >= center_pixel;
            binary_pattern(3) = gray_image(i-1, j+1) >= center_pixel;
            binary_pattern(4) = gray_image(i, j+1) >= center_pixel;
            binary_pattern(5) = gray_image(i+1, j+1) >= center_pixel;
            binary_pattern(6) = gray_image(i+1, j) >= center_pixel;
            binary_pattern(7) = gray_image(i+1, j-1) >= center_pixel;
            binary_pattern(8) = gray_image(i, j-1) >= center_pixel;
            lbp_value = binary_pattern * (2 .^ (7:-1:0))'; % Konversi biner ke desimal
            lbp_image(i, j) = lbp_value;
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           PELATIHAN RANDOM FOREST
function pushbutton8_Callback(hObject, ~, handles)
    % Mendapatkan data dari uitable1
    hsv_data = get(handles.uitable1, 'Data');

    % Mendapatkan nilai Mean, Standar Deviasi, dan Skewness untuk setiap komponen HSV
    H_mean = hsv_data{1, 1};
    H_std = hsv_data{1, 2};
    H_skew = hsv_data{1, 3};

    S_mean = hsv_data{2, 1};
    S_std = hsv_data{2, 2};
    S_skew = hsv_data{2, 3};

    V_mean = hsv_data{3, 1};
    V_std = hsv_data{3, 2};
    V_skew = hsv_data{3, 3};

    % Siapkan data pelatihan
    training_data = [H_mean, H_std, H_skew;
                     S_mean, S_std, S_skew;
                     V_mean, V_std, V_skew];

    % Siapkan label untuk setiap vektor fitur
    labels = {'early blight', 'late blight', 'healthy'};

    % Siapkan model Random Forest dengan parameter yang sesuai
    num_trees = 1000; 
    model = TreeBagger(num_trees, training_data, labels);

    % Simpan model yang telah dilatih pada handles
    handles.model = model;
    guidata(hObject, handles);

    msgbox('Pelatihan model Random Forest selesai.', 'Info', 'modal');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               TAMPILKAN HASIL
function pushbutton11_Callback(~, ~, handles)
    % Pastikan model Random Forest sudah dilatih
    if ~isfield(handles, 'model')
        msgbox('Mohon lakukan pelatihan model terlebih dahulu.', 'Error', 'error');
        return;
    end

    % Mendapatkan data dari uitable1
    hsv_data = get(handles.uitable1, 'Data');

    % Mendapatkan nilai Mean, Standar Deviasi, dan Skewness untuk setiap komponen HSV
    H_mean = hsv_data{1, 1};
    H_std = hsv_data{1, 2};
    H_skew = hsv_data{1, 3};

    S_mean = hsv_data{2, 1};
    S_std = hsv_data{2, 2};
    S_skew = hsv_data{2, 3};

    V_mean = hsv_data{3, 1};
    V_std = hsv_data{3, 2};
    V_skew = hsv_data{3, 3};

    % Siapkan data uji untuk prediksi
    test_data = [H_mean, H_std, H_skew;
                 S_mean, S_std, S_skew;
                 V_mean, V_std, V_skew];

    % Lakukan prediksi dengan model Random Forest yang telah dilatih
    [~, scores] = predict(handles.model, test_data');

    % Mendapatkan indeks kelas dengan probabilitas tertinggi untuk setiap sampel
    [~, predicted_index] = max(scores, [], 2);

    % Mengambil label hasil prediksi berdasarkan index yang memiliki probabilitas tertinggi
    predicted_disease = handles.model.ClassNames{predicted_index};

    % Tampilkan hasil prediksi dalam sebuah popup
    result_msg = ['Hasil prediksi: ', predicted_disease];
    msgbox(result_msg, 'Hasil Prediksi', 'modal');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           SIMPAN HASIL
function pushbutton12_Callback(~, ~, handles)
    % Mendapatkan data dari uitable1
    hsv_data = get(handles.uitable1, 'Data');

    % Mendapatkan nilai Mean, Standar Deviasi, dan Skewness untuk setiap komponen HSV
    H_mean = hsv_data{1, 1};
    H_std = hsv_data{1, 2};
    H_skew = hsv_data{1, 3};

    S_mean = hsv_data{2, 1};
    S_std = hsv_data{2, 2};
    S_skew = hsv_data{2, 3};

    V_mean = hsv_data{3, 1};
    V_std = hsv_data{3, 2};
    V_skew = hsv_data{3, 3};

    % Siapkan data uji untuk prediksi
    test_data = [H_mean, H_std, H_skew;
                 S_mean, S_std, S_skew;
                 V_mean, V_std, V_skew];

    % Lakukan prediksi dengan model Random Forest yang telah dilatih
    predicted_label = predict(handles.model, test_data');

    % Simpan hasil prediksi ke dalam file teks
    file_path = 'hasil_prediksi.txt';
    fid = fopen(file_path, 'w');
    fprintf(fid, 'Hasil prediksi: %s\n', predicted_label{1}); % Hilangkan char() di sini
    fclose(fid);

    % Simpan citra yang sedang ditampilkan di GUI
    output_image = getframe(handles.axes3); % Mendapatkan frame dari axes3
    imwrite(output_image.cdata, 'hasil_prediksi_image.png'); % Simpan sebagai gambar PNG

    % Tampilkan pesan sukses
    msgbox(['Hasil prediksi dan gambar telah disimpan dalam file: ' file_path], 'Sukses', 'modal');
