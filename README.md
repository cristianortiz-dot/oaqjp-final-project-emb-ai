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
