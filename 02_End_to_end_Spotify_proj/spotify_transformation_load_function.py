import json
import boto3
from datetime import datetime
from io import StringIO
import pandas as pd

def album(data):
    album_list = []
    for i in data['items']:
        album_id = i['track']['album']['id']
        album_name = i['track']['album'] ['name']
        album_realse_date = i['track']['album'] ['release_date']
        album_total_tracks = i ['track']['album'] ['total_tracks']
        album_url = i['track']['album'] ['external_urls']['spotify']
        album_element = {'album_id':album_id, 'album_name':album_name,'album_realse_date':album_realse_date, 
                         'album_total_tracks':album_total_tracks, 'album_url':album_url }
        album_list.append(album_element)
    return album_list 
    
def artist(data):
    artist_list = []
    for i in data['items']:
        for key,value in i.items():
            if key == 'track':
                for artist in  value['artists']:
                    artist_dic = { 
                        'artist_id' :artist['id'],
                        'artist_name':artist['name'],
                        'artist_type':artist['type'],
                        'artist_link':artist['href']
                                 }
                    artist_list.append(artist_dic)
    return artist_list
    
def songs(data):
    songs_list = []
    for i in data['items']:
        song_id = i['track']['id']
        song_name = i['track']['name']
        song_duration = i ['track']['duration_ms']
        song_url = i ['track']['external_urls']['spotify']
        song_popularity = i['track']['popularity']
        song_added = i['added_at']
        album_id = i['track']['album']['id']
        artist_id = i ['track']['album']['artists'][0]['id']
        songs_element = {
            'song_id':song_id,
            'song_name':song_name,
            'song_duration':song_duration,
            'song_url':song_url,
            'song_popularity':song_popularity,
            'song_added':song_added,
            'album_id':album_id,
            'artist_id':artist_id
        }
        songs_list.append(songs_element)
    return songs_list
    

def lambda_handler(event, context):
    s3 = boto3.client('s3')
    Bucket = "spotify-etl-project-naga"
    Key = "raw_data/to_processed/"
    
    spotify_data= []
    spotify_keys = []
    for file in s3.list_objects(Bucket= Bucket,Prefix = Key)['Contents']:
        file_key = file['Key']
        if file_key.split('.')[-1] == 'json':
            response = s3.get_object(Bucket= Bucket, Key= file_key)
            content = response['Body']
            jsonObject = json.loads(content.read())
            spotify_data.append(jsonObject)
            spotify_keys.append(file_key)
    print(spotify_keys)
    
    
    for i in spotify_data:
        album_list = album(i)
        artist_list = artist(i)
        songs_list = songs(i)
        
        album_df = pd.DataFrame.from_dict(album_list)
        album_df = album_df.drop_duplicates(subset= ['album_id'])
        
        artist_df = pd.DataFrame.from_dict(artist_list)
        artist_df = artist_df.drop_duplicates(subset=['artist_id'])
        
        songs_df = pd.DataFrame.from_dict(songs_list)
        
        album_df['album_realse_date'] = pd.to_datetime(album_df['album_realse_date'])
        songs_df['song_added'] = pd.to_datetime(songs_df['song_added'])
        
        song_key = 'transformed_data/songs_data/songs_transformed_' + str(datetime.now()) + '.csv' 
        song_buffer = StringIO()
        songs_df.to_csv(song_buffer,index= False)
        song_content = song_buffer.getvalue()
        s3.put_object(Bucket = Bucket, Key = song_key , Body = song_content)
        
        album_key = 'transformed_data/album_data/album_transformed_' + str(datetime.now()) +'.csv'
        album_buffer = StringIO()
        album_df.to_csv(album_buffer, index= False)
        album_content = album_buffer.getvalue()
        s3.put_object(Bucket= Bucket, Key= album_key, Body = album_content)
        
        
        artist_key = 'transformed_data/artist_data/artist_transformed_' + str(datetime.now()) + '.csv'
        artist_buffer = StringIO()
        artist_df.to_csv(artist_buffer ,index= False)
        artist_content = artist_buffer.getvalue()
        s3.put_object(Bucket= Bucket, Key= artist_key, Body= artist_content)
    
    
    source_bucket = Bucket
    source_folder = 'raw_data/to_processed/'
    destination_folder = 'raw_data/processed/'
    
    for file_name in spotify_keys:
        copy_source = {'Bucket': source_bucket, 'Key': file_name}
        destination_key = destination_folder + file_name.split('/')[-1]
        
        # Copy the file to the new location
        s3.copy_object(CopySource=copy_source, Bucket=source_bucket, Key=destination_key)
        print(f"Copied {file_name} to {destination_key}")
        
        # Delete the original file
        s3.delete_object(Bucket=source_bucket, Key=file_name)
        print(f"Deleted {file_name} from {source_folder}")
        
    
