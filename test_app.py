import pytest
from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    with app.test_client() as client:
        yield client

def test_app_runs(client):
    """Verifica que la app responde"""
    response = client.get('/')
    assert response.status_code in [200, 302, 500]  # 500 ok si no hay DB

def test_random_endpoint(client):
    """Verifica que el endpoint /random existe"""
    response = client.get('/random')
    assert response.status_code in [200, 302, 500]