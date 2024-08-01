import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from flask import Flask,request,jsonify,send_file
import numpy as np
import librosa
import wave
import pandas as pd
import soundfile as sf
import librosa.display
from PIL import Image
import os
import tensorflow as tf
import scipy.signal as signal

app = Flask(__name__)

model1 = tf.keras.models.load_model("/Users/vaishnavikrovvidi/Desktop/heart/flask/heart_spect_mobilenet_aug_actual.hdf5")
model = tf.keras.models.load_model('/Users/vaishnavikrovvidi/Desktop/heart/flask/weights.best.basic_cnn.hdf5')

d ={ 0: 'air_conditioner', 1: 'car_horn', 2: 'children_playing', 3: 'dog_bark', 4: 'drilling', 5: 'engine_idling', 6:'gun_shot', 7: 'jackhammer', 8: 'siren', 9: 'street_music'}


def plot_graphs(filename):
    plt.figure(figsize=(5, 2))
    data, sample_rate = librosa.load(filename)
    librosa.display.waveshow(data, sr=sample_rate)
    plt.savefig("/Users/vaishnavikrovvidi/Desktop/heart/flask/trash1/wave.png")
    plt.close()
    spectrogram = librosa.feature.melspectrogram(y=data, sr=sample_rate)
    spectrogram_db = librosa.power_to_db(spectrogram, ref=np.max)
    plt.figure(figsize=(3.5,3.5))
    librosa.display.specshow(spectrogram_db, sr=sample_rate,x_axis='time', y_axis='log')
    plt.savefig("/Users/vaishnavikrovvidi/Desktop/heart/flask/trash1/spectrogram.png", transparent=True)
    plt.close()
    

def delete_files_in_folder(folder_path):
    for file_name in os.listdir(folder_path):
        file_path = os.path.join(folder_path, file_name)
        if os.path.isfile(file_path):
            os.remove(file_path)
            print(f"Deleted file: {file_path}")

def save_spect_testing(data, sr, filename,i):
    # Extract spectrogram
    spectrogram = librosa.feature.melspectrogram(y=data, sr=sr)

    # Convert to decibels
    spectrogram_db = librosa.power_to_db(spectrogram, ref=np.max)

    # Plot spectrogram
    plt.figure(figsize=(1.28,1.28))
    librosa.display.specshow(spectrogram_db, sr=sr)
    plt.savefig(("/Users/vaishnavikrovvidi/Desktop/heart/flask/trash/{}_{}.png").format(filename,i), transparent=True)
    plt.close()

# Step 1: Denoising using a low pass filter
def apply_low_pass_filter(audio, sampling_rate, cutoff_freq):
    nyquist_freq = 0.5 * sampling_rate
    normalized_cutoff_freq = cutoff_freq / nyquist_freq
    b, a = signal.butter(4, normalized_cutoff_freq, btype='low', analog=False)
    denoised_audio = signal.lfilter(b, a, audio)
    return denoised_audio

# Downsampling audio
def downsample_audio(audio,original_sampling_rate,target_sampling_rate):
    resampled_audio = librosa.resample(audio, orig_sr=original_sampling_rate, target_sr=target_sampling_rate)
    return resampled_audio

# Split audio into fixed-length segments
def split_audio(audio, segment_length):
    num_segments = len(audio) // segment_length
    segments = [audio[i*segment_length:(i+1)*segment_length] for i in range(num_segments)]
    return segments

def preds(audio_path, model,filename):
    m=0
    p=""

    audio, sampling_rate = librosa.load(audio_path, sr=None)
    cutoff_frequency = 195
    denoised_audio = apply_low_pass_filter(audio, sampling_rate, cutoff_frequency)
    target_sampling_rate = sampling_rate // 10
    downsampled_audio = downsample_audio(denoised_audio, sampling_rate, target_sampling_rate)
    segment_length = target_sampling_rate * 3
    segments = split_audio(downsampled_audio, segment_length)
    i=0
    
    for segment in segments:
        save_spect_testing(segment,target_sampling_rate,filename,i)
        img=Image.open(("/Users/vaishnavikrovvidi/Desktop/heart/flask/trash/{}_{}.png").format(filename,i)).convert('RGB')
        img_arr=np.asarray(img)
        img_arr=img_arr/255
        img_arr = img_arr.reshape(1, 128, 128, 3)
        prediction = model1.predict(img_arr)
        x=np.argmax(prediction)
        confidence = prediction[0, x]
        i=i+1
        classes={0:'Artifact', 1:'Extrasystole', 2:'Murmur', 3:'Normal'}
        if(confidence>m):
            m=confidence
            p=classes[x]
        print(classes[x],confidence)
    return(p)
def func(filename):
    max_pad_len = 174
    audio, sample_rate = librosa.load(filename)
    mfccs = librosa.feature.mfcc(y=audio, sr=sample_rate, n_mfcc=40)
    pad_width = max_pad_len - mfccs.shape[1]
    mfccs = np.pad(mfccs, pad_width=((0, 0), (0, pad_width)), mode='constant')
    mfccs = mfccs.reshape(40,174,1)
    batch_size=1
    mfccs=np.reshape(mfccs,(batch_size,)+ mfccs.shape)
    pred =(np.argmax(model.predict(mfccs)))
    if pred == normal:
        print("May not have Heart Disease")
    else:
        print("May have Heart Disease")
    
    return d[pred]

@app.route('/predict',methods=['POST'])
def predict():
    if 'audio' not in request.files:
        return 'No file provided', 400

    audio_file = request.files['audio']
    if not audio_file.filename.lower().endswith('.wav'):
        return 'Invalid file type, must be .wav', 400
    prediction = preds(audio_file, model1, "file")
    delete_files_in_folder("/Users/vaishnavikrovvidi/Desktop/heart/flask/trash")
    return (prediction)

@app.route('/pred',methods=['POST'])
def pred():
    if 'audio' not in request.files:
        return 'No file provided', 400

    audio_file = request.files['audio']
    if not audio_file.filename.lower().endswith('.wav'):
        return 'Invalid file type, must be .wav', 400
    prediction = func(audio_file)
    print(prediction)
    return prediction

@app.route('/plot', methods=['GET'])
def serve_plot():
    # Return the image file
    return send_file("/Users/vaishnavikrovvidi/Desktop/heart/flask/trash1/wave.png", mimetype='image/png')
    
@app.route('/spect', methods=['GET'])
def serve_spect():
    # Return the image file
    return send_file("/Users/vaishnavikrovvidi/Desktop/heart/flask/trash1/spectrogram.png", mimetype='image/png')

if __name__ == '__main__':
    app.run(debug=True)


# audio_path=r"C:\Users\bharg\Desktop\Heart_Sounds\murmur_1.wav"
# pred(audio_path,model,"mur")

