"""Módulo que detecta emociones en un texto usando Watson NLP."""
import json
import requests


def emotion_detector(text_to_analyse):
    """Envía el texto al servicio Watson NLP y devuelve un diccionario
    con los puntajes de cada emoción y la emoción dominante.

    Si el texto de entrada está vacío o el servicio responde con un
    error 400, todos los valores se devuelven como None.
    """
    url = ('https://sn-watson-emotion.labs.skills.network/v1/'
           'watson.runtime.nlp.v1/NlpService/EmotionPredict')
    headers = {"grpc-metadata-mm-model-id": "emotion_aggregated-workflow_lang_en_stock"}
    input_json = {"raw_document": {"text": text_to_analyse}}

    response = requests.post(url, json=input_json, headers=headers, timeout=10)

    if response.status_code == 400:
        return {
            'anger': None,
            'disgust': None,
            'fear': None,
            'joy': None,
            'sadness': None,
            'dominant_emotion': None
        }

    formatted_response = json.loads(response.text)
    emotion_scores = formatted_response['emotionPredictions'][0]['emotion']

    anger = emotion_scores['anger']
    disgust = emotion_scores['disgust']
    fear = emotion_scores['fear']
    joy = emotion_scores['joy']
    sadness = emotion_scores['sadness']

    scores = {'anger': anger, 'disgust': disgust, 'fear': fear,
              'joy': joy, 'sadness': sadness}
    dominant_emotion = max(scores, key=scores.get)

    return {
        'anger': anger,
        'disgust': disgust,
        'fear': fear,
        'joy': joy,
        'sadness': sadness,
        'dominant_emotion': dominant_emotion
    }
