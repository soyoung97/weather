# 기상과학원 검색기 docker file


## Docker image 내려받기
먼저 사용되는 코드와 모델이 들어있는 docker image를 docker hub에서 내려받습니다.
```
sudo docker pull msyoon8/weather:latest
```
## Docker image 실행하기

```
sudo docker run -d -p 8887:8887 --gpus all msyoon8/weather:latest python3 home/KoBART-summarization/run_api.py 8887
```
- Port number는 원하시는 port로 지정하실 수 있습니다. (위의 예시에서 port number는 8887)
- 주의: gpu 가 available한 machine이여야 합니다.
- GET 형태의 형식에 맞는 요청을 보내면, 아래 예시와 같은 pseudo url을 output합니다.

## Example

![request_example](./request_example.png)

- [advanced rest client](https://chrome.google.com/webstore/detail/advanced-rest-client/hgmloofddffdnphfgcellkdfbfbjeloo/related) 를 이용해 정상 동작 여부를 확인하였습니다.
