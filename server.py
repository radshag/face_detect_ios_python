#prerequisites: install Flask via pip (pip install Flask)
import httplib, urllib, base64
import ssl
import json
from flask import Flask
from flask import request
from flask import jsonify
import sys
app = Flask(__name__)

API_HOST = '0.0.0.0'
API_PORT = '8089'
FACE_API_KEY = "{INSERT KEY HERE}"
ssl._create_default_https_context = ssl._create_unverified_context

@app.route('/')
def hello():
    return "/detectfaces for image face detection"


@app.route('/detectfaces', methods=['POST'])
def uploadimage():
    image_data = request.files["image_data"]

    headers = {
        # Request headers
        'Content-Type': 'application/octet-stream',
        'Ocp-Apim-Subscription-Key': FACE_API_KEY,
    }

    params = urllib.urlencode({
        # Request parameters
        'returnFaceId': 'true',
        'returnFaceLandmarks': 'false',
        'returnFaceAttributes': 'emotion',
    })

    try:
        conn = httplib.HTTPSConnection('westcentralus.api.cognitive.microsoft.com')
        conn.request("POST", "/face/v1.0/detect?%s" % params, image_data, headers)
        response = conn.getresponse()
        data = response.read()
        parsed_json = json.loads(data)
        score = 0
        has_face = False
        for face_json in parsed_json:
            has_face = True
            faceId = face_json['faceId']
            faceRectangle = face_json['faceRectangle']
            for emotion in face_json['faceAttributes']['emotion']:
                temp_score = face_json['faceAttributes']['emotion'][emotion]
                if (temp_score > score):
                    score = temp_score
                    face_emotion = emotion
            break

        conn.close()
    except Exception as e:
        return jsonify({"rc": 1, "message": "We have lost track of what we were doing. Please try again ;)" })

    if has_face == True:
        return jsonify({"rc": 0, "faceId": faceId, "faceRectangle": faceRectangle, "emotion": face_emotion})
    else:
        return jsonify({"rc": 100, "message": "No faces were detected" })

if __name__ == '__main__':
	app.run(host=API_HOST, port=API_PORT)
