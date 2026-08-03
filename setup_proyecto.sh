#!/bin/bash
# Ejecuta este script DENTRO de la terminal del Cloud IDE de Skills Network,
# ya parado dentro de la carpeta de tu fork clonado.
set -e

mkdir -p EmotionDetection templates static

cat > EmotionDetection/emotion_detection.py << 'PYEOF_EmotionDetection_emotion_detection_py'
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
PYEOF_EmotionDetection_emotion_detection_py

cat > EmotionDetection/__init__.py << 'PYEOF_EmotionDetection___init___py'
"""Paquete EmotionDetection: expone la función emotion_detector."""
from .emotion_detection import emotion_detector
PYEOF_EmotionDetection___init___py

cat > test_emotion_detection.py << 'PYEOF_test_emotion_detection_py'
"""Pruebas unitarias para la función emotion_detector."""
import unittest
from EmotionDetection.emotion_detection import emotion_detector


class TestEmotionDetection(unittest.TestCase):
    """Valida que cada frase de prueba arroje la emoción dominante esperada."""

    def test_emotion_detector(self):
        """Comprueba las 5 emociones dominantes: joy, anger, disgust, sadness, fear."""
        result_joy = emotion_detector("I am glad this happened")
        self.assertEqual(result_joy['dominant_emotion'], 'joy')

        result_anger = emotion_detector("I am really mad about this")
        self.assertEqual(result_anger['dominant_emotion'], 'anger')

        result_disgust = emotion_detector("I feel disgusted just hearing about this")
        self.assertEqual(result_disgust['dominant_emotion'], 'disgust')

        result_sadness = emotion_detector("I am so sad about this")
        self.assertEqual(result_sadness['dominant_emotion'], 'sadness')

        result_fear = emotion_detector("I am really afraid that this will happen")
        self.assertEqual(result_fear['dominant_emotion'], 'fear')


if __name__ == '__main__':
    unittest.main()
PYEOF_test_emotion_detection_py

cat > server.py << 'PYEOF_server_py'
"""Servidor Flask que expone la aplicación de detección de emociones."""
from flask import Flask, render_template, request
from EmotionDetection.emotion_detection import emotion_detector

app = Flask("Emotion Detector")


@app.route("/emotionDetector")
def sent_analyzer():
    """Recibe el texto por query string, lo analiza y devuelve el resultado formateado."""
    text_to_analyze = request.args.get('textToAnalyze')
    response = emotion_detector(text_to_analyze)

    if response['dominant_emotion'] is None:
        return "Invalid text! Please try again!"

    return (
        f"For the given statement, the system response is 'anger': {response['anger']}, "
        f"'disgust': {response['disgust']}, 'fear': {response['fear']}, "
        f"'joy': {response['joy']} and 'sadness': {response['sadness']}. "
        f"The dominant emotion is {response['dominant_emotion']}."
    )


@app.route("/")
def render_index_page():
    """Renderiza la página principal."""
    return render_template('index.html')


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
PYEOF_server_py

cat > templates/index.html << 'PYEOF_templates_index_html'
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Emotion Detector</title>
    <script src="/static/mywebscript.js"></script>
</head>
<body>
    <h1>Detector de Emociones (Watson NLP)</h1>
    <label for="textToAnalyze">Escribe una frase en inglés:</label><br>
    <input type="text" id="textToAnalyze" size="60">
    <button onclick="RunSentimentAnalysis()">Analizar</button>
    <p id="system_response"></p>
</body>
</html>
PYEOF_templates_index_html

cat > static/mywebscript.js << 'PYEOF_static_mywebscript_js'
let RunSentimentAnalysis = () => {
    let textToAnalyze = document.getElementById("textToAnalyze").value;
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            document.getElementById("system_response").innerHTML = this.responseText;
        }
    };
    xhttp.open("GET", "/emotionDetector?textToAnalyze=" + encodeURIComponent(textToAnalyze), true);
    xhttp.send();
};
PYEOF_static_mywebscript_js

cat > requirements.txt << 'PYEOF_requirements_txt'
flask
requests
pylint
PYEOF_requirements_txt

cat > README.md << 'PYEOF_README_md'
# Emotion Detection with Watson NLP - Proyecto Final

Aplicación web desarrollada con Flask que utiliza la biblioteca Watson NLP
para detectar emociones (ira, disgusto, miedo, alegría, tristeza) en un
texto y determinar la emoción dominante.

## Estructura del proyecto

```
proyecto_final_flask/
├── EmotionDetection/
│   ├── __init__.py
│   └── emotion_detection.py
├── templates/
│   └── index.html
├── static/
│   └── mywebscript.js
├── test_emotion_detection.py
├── server.py
├── requirements.txt
└── README.md
```

## Instalación

```bash
pip install -r requirements.txt
```

## Ejecución de pruebas unitarias

```bash
python -m unittest test_emotion_detection.py
```

## Despliegue local

```bash
python server.py
```

Luego abre `http://localhost:5000` en el navegador.

## Análisis de código estático

```bash
pylint server.py
```
PYEOF_README_md

echo "Archivos creados."
