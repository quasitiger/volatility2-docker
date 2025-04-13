# Volatility 3 (Alpine 기반 Docker 이미지)

경량화된 Alpine 리눅스 기반의 [Volatility 3](https://github.com/volatilityfoundation/volatility3) 메모리 포렌식 도구입니다.  
공식 커뮤니티 플러그인 외에도 YARA, MalConfScan, cobaltstrikescan 등 다양한 플러그인이 포함되어 있어 실전 분석에 적합합니다.

---

## 🧠 주요 기능

- ✅ Volatility 2 마지막 버전
- ✅ YARA + yara-python 지원 (v3.11.0)
- ✅ community 플러그인 기본 탑재
- ✅ cobaltstrikescan, MalConfScan, dnscache, winesap 포함
- ✅ Alpine 기반으로 이미지 크기 최소화
- ✅ `dumb-init`을 통한 안정적 실행 (PID 1 문제 해결)
- ✅ 비루트 사용자 실행 (보안성 강화)

---

## 🚀 빠른 시작

```bash
docker run --rm -v $(pwd)/mem:/data quasitiger/volatility2 -f /data/memdump.raw windows.info
docker run -it --entrypoint /bin/sh quasitiger/volatility2
```

---

## 😊 출처

### Based on https://github.com/sk4la/volatility3-docker
### Based on https://hub.docker.com/r/sk4la/volatility
Original author: sk4la (MIT License)
Modified and published by: tiger (quasitiger)

이 이미지는 sk4la/volatility3-docker 오픈소스 프로젝트를 기반으로 제작되었으며,
MIT 라이선스에 따라 재배포됩니다.

원저자: sk4la
라이선스: MIT
수정 및 배포자: tiger (quasitiger)

