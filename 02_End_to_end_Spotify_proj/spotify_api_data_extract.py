import json
import os
import spotipy 
from spotipy.oauth2 import SpotifyClientCredentials 
import boto3
from datetime import datetime

def lambda_handler(event, context): 
    
    # gettin secret id from env variables
    client_id = os.environ.get('client_id')
    client_secret = os.environ.get('client_secret')
    
    client_credentials_manager = SpotifyClientCredentials(client_id=client_id, client_secret=client_secret)
    sp = spotipy.Spotify(client_credentials_manager = client_credentials_manager)
    playlists = sp.user_playlists('spotify')
    
    playlist_link = "https://open.spotify.com/playlist/37i9dQZEVXbNG2KDcFcKOF?si=1333723a6eff4b7f"
    playlist_URI = playlist_link.split("/")[-1].split('?')[0]
    
    spotify_data = sp.playlist_tracks(playlist_URI)
    print(spotify_data)
    
    client = boto3.client('s3')  # This line is not indented correctly
    response = client.list_buckets()  # This line is not indented correctly
    print("Existing buckets:") 
    
    file_name = "spotify_raw_" + str(datetime.now()) +".json"
    client.put_object(
        Bucket = "spotify-etl-project-naga",
        Key = "raw_data/to_processed/" + file_name ,
        Body = json.dumps(spotify_data)
        )
