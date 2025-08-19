// 모든 랜드마크 정보
const landmarkData = [
    { name: '경복궁', lat: 37.5796, lng: 126.9770, country: 'South Korea', description: '조선 왕조의 법궁으로, 아름다운 건축미를 자랑합니다.' },
    { name: '남산 서울타워', lat: 37.5512, lng: 126.9882, country: 'South Korea', description: '서울의 대표적인 랜드마크이자 관광 명소입니다.' },
    { name: '만리장성', lat: 40.4319, lng: 116.5704, country: 'China', description: '고대 중국의 성벽으로, 인류 역사상 가장 큰 건축물 중 하나입니다.' },
    { name: '자금성', lat: 39.9163, lng: 116.3972, country: 'China', description: '명청 시대의 궁궐로, 세계에서 가장 큰 고대 궁전입니다.' },
    { name: '도쿄 타워', lat: 35.6586, lng: 139.7454, country: 'Japan', description: '일본 도쿄 미나토구에 있는 전파탑이자 랜드마크입니다.' },
    { name: '타지마할', lat: 27.1751, lng: 78.0421, country: 'India', description: '인도 무굴 제국의 아름다운 묘지 건축물입니다.' },
    { name: '에펠탑', lat: 48.8584, lng: 2.2945, country: 'France', description: '파리의 상징이자 대표적인 랜드마크입니다.' },
    { name: '루브르 박물관', lat: 48.8606, lng: 2.3376, country: 'France', description: '세계에서 가장 크고 중요한 박물관 중 하나입니다.' },
    { name: '피사의 사탑', lat: 43.7230, lng: 10.3966, country: 'Italy', description: '이탈리아 피사에 있는 기울어진 종탑입니다.' },
    { name: '콜로세움', lat: 41.8902, lng: 12.4922, country: 'Italy', description: '고대 로마 시대의 거대한 원형 경기장 유적입니다.' },
    { name: '로마 판테온', lat: 41.8986, lng: 12.4768, country: 'Italy', description: '고대 로마의 신전으로, 완벽한 건축 기술을 보여줍니다.' },
    { name: '사그라다 파밀리아', lat: 41.4037, lng: 2.1744, country: 'Spain', description: '스페인 바르셀로나에 있는 건축가 가우디의 미완성 대성당입니다.' },
    { name: '빅벤', lat: 51.5007, lng: -0.1246, country: 'United Kingdom', description: '런던 웨스트민스터 궁전의 시계탑입니다.' },
    { name: '엠파이어 스테이트 빌딩', lat: 40.7484, lng: -73.9857, country: 'United States of America', description: '뉴욕 맨해튼에 있는 유명한 마천루입니다.' },
    { name: '자유의 여신상', lat: 40.6892, lng: -74.0445, country: 'United States of America', description: '미국 뉴욕 항에 있는 거대한 여신상으로, 자유와 민주주의의 상징입니다.' },
    { name: '그랜드 캐니언', lat: 36.1016, lng: -112.1129, country: 'United States of America', description: '미국 애리조나주에 있는 웅장한 협곡입니다.' },
    { name: '마추픽추', lat: -13.1631, lng: -72.5450, country: 'Peru', description: '페루 안데스 산맥에 있는 잉카 문명의 고대 도시 유적입니다.' },
    { name: '크라이스트 더 리디머', lat: -22.9519, lng: -43.2105, country: 'Brazil', description: '브라질 리우데자네이루 코르코바도 산 꼭대기에 있는 거대한 예수상입니다.' },
    { name: '시드니 오페라 하우스', lat: -33.8568, lng: 151.2153, country: 'Australia', description: '호주 시드니의 상징적인 복합 문화 예술 공간입니다.' },
    { name: '피라미드', lat: 29.9792, lng: 31.1342, country: 'Egypt', description: '고대 이집트 왕들의 무덤으로, 세계 7대 불가사의 중 하나입니다.' }
];
