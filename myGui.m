function rc4_gui
    clear; clc;
    % Initialize figure and UI components
    fig = uifigure('Name', 'RC4 Encryption/Decryption', 'Position', [100 100 400 200]);
    key_label = uilabel(fig, 'Position', [20 150 80 22], 'Text', 'Enter Key:');
    key_field = uieditfield(fig, 'Position', [100 150 200 22], 'Value', '');
    enc_button = uibutton(fig, 'Position', [120 50 80 22], 'Text', 'Encrypt', 'ButtonPushedFcn', @encrypt_img);
    dec_button = uibutton(fig, 'Position', [220 50 80 22], 'Text', 'Decrypt', 'ButtonPushedFcn', @decrypt_img);

    function encrypt_img(~, ~)
        key = key_field.Value;
        img = imread(imgetfile);
        
        if ~isempty(key) && ~isempty(img)
            img = rgb2gray(img);
            T = imresize(img, [256 256]);
            [M, N] = size(T);
            C = reshape(T, 1, M*N);
            plaintext = double(C);
            key_len = size(key, 2);
            p_len = size(plaintext, 2);

            S = 0:255;
            j = 0;
            for i=0:255
                F = mod(i,key_len);
                j = mod(j+S(i+1)+key(F+1),256);
                S([i+1 j+1]) = S([j+1 i+1]);
            end

            j = 0;
            j = 0;
            key = uint16([]);
            n = p_len;

            while n>0
                n = n-1;
                i = mod(i+1, 256);
                S([i+1 j+1]) = S([j+1 i+1]);
                k = S(mod(S(i+1)+S(j+1), 256)+1);
                key = [key, k];

            end
            z = uint8(key);
            p = uint8(char(plaintext));
            res = bitxor(z, p);

            H = double(res);
            C_img = uint8(reshape(H, M, N));
            imtool(C_img);
            imwrite(C_img, 'RC4_Enc_Image.bmp');
        else
            uialert(fig, 'Please select an image file and enter a key', 'Error');
        end
    end

    function decrypt_img(~, ~)
        key = key_field.Value;
        img = imread(imgetfile);
        
        if ~isempty(key) && ~isempty(img)
            T = imresize(img, [256 256]);
            [M, N] = size(T);
            C = reshape(T, 1, M*N);
            ciphertext = double(C);
            key_len = size(key, 2);
    
            S = 0:255;
            j = 0;
            for i=0:255
                F = mod(i,key_len);
                j = mod(j+S(i+1)+key(F+1),256);
                S([i+1 j+1]) = S([j+1 i+1]);
            end
    
            j = 0;
            key = uint16([]);
            n = length(ciphertext);
    
            while n>0
                n = n-1;
                i = mod(i+1, 256);
                S([i+1 j+1]) = S([j+1 i+1]);
                k = S(mod(S(i+1)+S(j+1), 256)+1);
                key = [key, k];
            end
    
            z = uint8(key);
            c = uint8(char(ciphertext));
            res = bitxor(z, c);
            D = double(res);
            D_img = uint8(reshape(D, M, N));
            imtool(D_img);
            imwrite(D_img, 'RC4_Dec_Image.bmp');
        else
            uialert(fig, 'Please select an image file and enter a key', 'Error');
        end
end

end