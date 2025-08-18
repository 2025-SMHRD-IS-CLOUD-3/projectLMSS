const restaurantInfo = {
     '경복궁': [
        { name: '토속촌 삼계탕', lat: 37.5801, lng: 126.9749, category: '한식', rating: 4.5, description: '전통 있는 삼계탕 맛집으로, 인삼향이 가득한 국물이 일품입니다.' },
        { name: '효자동 베이커리', lat: 37.5796, lng: 126.9723, category: '베이커리', rating: 4.2, description: '다양한 빵과 디저트를 판매하는 동네 빵집으로 유명합니다.' },
        { name: '광화문 미진', lat: 37.5729, lng: 126.9769, category: '국수', rating: 4.3, description: '담백한 국수와 만두가 유명한 전통 국수집입니다.' },
        { name: '북촌 손만두', lat: 37.5825, lng: 126.9814, category: '한식', rating: 4.4, description: '갓 만든 손만두가 인기인 북촌 전통 음식점입니다.' },
        { name: '삼청동 수제비', lat: 37.5863, lng: 126.9821, category: '한식', rating: 4.3, description: '쫄깃한 수제비와 칼칼한 국물이 인기입니다.' },
        { name: '경복궁 찻집', lat: 37.5779, lng: 126.9745, category: '카페', rating: 4.1, description: '전통 다과와 함께 휴식을 즐길 수 있는 찻집입니다.' }
    ],
    '남산 서울타워': [
        { name: 'N서울타워 한쿡', lat: 37.5512, lng: 126.9882, category: '한식', rating: 4.0, description: '남산타워에 위치한 한식 뷔페로, 서울 전경을 보며 식사할 수 있습니다.' },
        { name: '목멱산방', lat: 37.5540, lng: 126.9897, category: '한식', rating: 4.7, description: '전통 비빔밥 맛집으로, 정갈한 한 끼를 즐기기에 좋습니다.' },
        { name: '남산돈까스', lat: 37.5553, lng: 126.9875, category: '양식', rating: 4.3, description: '두툼한 돈까스와 정갈한 반찬이 인기인 맛집입니다.' },
        { name: '카페 드 남산', lat: 37.5520, lng: 126.9855, category: '카페', rating: 4.2, description: '남산 전망을 보며 커피와 디저트를 즐길 수 있는 카페입니다.' },
        { name: '한남더힐 레스토랑', lat: 37.5363, lng: 126.9900, category: '퓨전 한식', rating: 4.6, description: '현대적 감각의 한식과 퓨전 요리를 맛볼 수 있는 레스토랑입니다.' },
        { name: '마루가메제면 남산점', lat: 37.5528, lng: 126.9908, category: '일식', rating: 4.4, description: '우동과 덮밥이 유명한 일본식 국수 전문점입니다.' }
    ],
    '만리장성': [
        { name: '콴쥐더(全聚德)', lat: 40.4310, lng: 116.5700, category: '중식', rating: 4.6, description: '북경 오리로 유명한 중국 대표 레스토랑입니다.' },
        { name: '더 그레이트 월 뷰 레스토랑', lat: 40.4300, lng: 116.5720, category: '중식', rating: 4.4, description: '만리장성 근처 전망 좋은 레스토랑으로 신선한 현지 요리를 제공합니다.' },
        { name: '만리장성 티 하우스', lat: 40.4325, lng: 116.5680, category: '카페', rating: 4.2, description: '만리장성 투어 후 휴식하기 좋은 전통 차와 간단한 스낵을 즐길 수 있는 곳입니다.' },
        { name: '하이디엔 로컬 푸드', lat: 40.4330, lng: 116.5715, category: '중식', rating: 4.5, description: '현지인이 추천하는 만리장성 주변의 맛집으로, 정통 베이징 가정식을 맛볼 수 있습니다.' }
    ],
    '자금성': [
        { name: '동베이차이관', lat: 39.9140, lng: 116.3980, category: '중식', rating: 4.3, description: '자금성 근처에 위치한 동북 요리 전문점으로, 가성비가 좋습니다.' },
        { name: '베이징 덕 레스토랑', lat: 39.9130, lng: 116.3975, category: '중식', rating: 4.7, description: '정통 베이징 덕을 맛볼 수 있는 고급 레스토랑입니다.' },
        { name: '궁중 요리 전문점', lat: 39.9120, lng: 116.3990, category: '중식', rating: 4.5, description: '궁중요리 스타일의 중국 전통 요리를 제공하는 곳입니다.' },
        { name: '자금성 소롱포', lat: 39.9145, lng: 116.4000, category: '중식', rating: 4.4, description: '신선한 재료로 만든 소롱포가 유명한 맛집입니다.' }
    ],
    '도쿄 타워': [
        { name: '우카이 테이', lat: 35.6580, lng: 139.7420, category: '철판요리', rating: 4.8, description: '도쿄 타워 근처에서 멋진 야경을 보며 식사할 수 있는 고급 철판 요리점입니다.' },
        { name: '토후야 우카이 (Tofuya Ukai)', lat: 35.6558, lng: 139.7483, category: '두부 요리', rating: 4.5, description: '도쿄 타워가 보이는 환상적인 정원에서 식사할 수 있는 고급 두부 가이세키 레스토랑입니다.' },
        { name: '노다이와 (Nodaiwa)', lat: 35.6601, lng: 139.7397, category: '장어 요리', rating: 4.3, description: '5대째 이어온 미슐랭 1스타 장어 전문점입니다. 역사를 자랑하는 최고의 장어 요리를 맛볼 수 있습니다.' },
        { name: '젝스 아타고 그린힐스', lat: 35.6675, lng: 139.7505, category: '이탈리안', rating: 4.5, description: '아타고 그린 힐즈 42층에 위치한 레스토랑으로, 도쿄의 야경을 한눈에 보며 식사할 수 있습니다.' }
    ],
    '타지마할': [
        { name: '피자헛 (아그라)', lat: 27.1740, lng: 78.0410, category: '양식', rating: 3.5, description: '아그라 지역에 위치한 패스트푸드 체인점으로, 간단한 식사를 할 수 있습니다.' },
        { name: '핀치 오브 스파이스 (Pinch of Spice)', lat: 27.171761, lng: 78.026411, category: '인도 요리', rating: 4.6, description: '현지인과 관광객 모두에게 인기 있는 레스토랑으로, 맛있는 인도 요리를 즐길 수 있습니다.' },
        { name: '페샤와리 (Peshawari)', lat: 27.171761, lng: 78.026411, category: '인도 요리', rating: 4.7, description: 'ITC 무굴 호텔 내에 위치한 고급 레스토랑으로, 북서부 인도 국경 지방의 특선 요리를 맛볼 수 있습니다.' }
    ],
    '에펠탑': [
        { name: '르 쥘베른', lat: 48.8576, lng: 2.2942, category: '프랑스 요리', rating: 4.9, description: '에펠탑 2층에 위치한 미슐랭 레스토랑으로, 환상적인 뷰를 자랑합니다.' },
        { name: 'Les Cocottes', lat: 48.8569, lng: 2.3015, category: '프랑스 요리', rating: 4.5, description: '에펠탑 근처에 위치한 빕 구르망 식당으로, 전통 프랑스 가정식 요리를 즐길 수 있습니다.' },
        { name: 'Bambini Paris', lat: 48.8637, lng: 2.2905, category: '이탈리아 요리', rating: 4.2, description: '팔레 드 도쿄에 위치한 이탈리안 레스토랑으로, 테라스에서 에펠탑 뷰를 감상할 수 있습니다.' }
    ],
    '루브르 박물관': [
        { name: '르 카페 마를리', lat: 48.8606, lng: 2.3360, category: '프랑스 요리', rating: 4.1, description: '루브르 박물관 근처에 위치한 카페로, 야외 테라스가 매력적입니다.' },
        { name: 'Bistrot Richelieu', lat: 48.8637, lng: 2.3364, category: '프랑스 요리', rating: 4.3, description: '루브르 박물관 근처에 있는 전통 프랑스식 비스트로로, 합리적인 가격에 달팽이 요리와 스테이크 등을 즐길 수 있습니다.' },
        { name: 'L\'Escargot Montorgueil', lat: 48.8653, lng: 2.3486, category: '프랑스 요리', rating: 4.4, description: '100년 넘는 역사를 가진 달팽이 요리 전문점으로, 다양한 맛의 에스카르고를 맛볼 수 있습니다.' }
    ],
    '피사의 사탑': [
        { name: '트라토리아 폰타나', lat: 43.7231, lng: 10.3958, category: '이탈리아 요리', rating: 4.4, description: '피사의 사탑 근처에서 정통 이탈리아 음식을 맛볼 수 있는 레스토랑입니다.' },
        { name: '오스테리아 인 도모 (Osteria in Domo)', lat: 43.7238, lng: 10.3965, category: '이탈리아 요리', rating: 4.3, description: '피사의 사탑에서 가까운 거리에 있는 레스토랑으로, 전통적인 토스카나 요리를 즐길 수 있습니다.' },
        { name: 'Ristorante Pizzeria L\'Europeo', lat: 43.7232, lng: 10.3962, category: '이탈리아 요리', rating: 4.4, description: '피사의 사탑에서 도보 1분 거리에 위치한 곳으로, 맛있는 이탈리안 음식과 피자를 맛볼 수 있습니다.' }
    ],
    '콜로세움': [
        { name: '오스테리아 레나타', lat: 41.8900, lng: 12.4930, category: '이탈리아 요리', rating: 4.6, description: '콜로세움 근처에서 로마의 전통 음식을 맛볼 수 있습니다.' },
        { name: '로마나 타베르나 (Taverna Romana)', lat: 41.8967, lng: 12.4938, category: '이탈리아 요리', rating: 4.5, description: '콜로세움에서 가까운 몬티 지구에 위치한 전통 로마 요리 전문점입니다. 예약이 필수일 정도로 인기가 많습니다.' },
        { name: '트라토리아 루찌 (Trattoria Luzzi)', lat: 41.8885, lng: 12.4984, category: '이탈리아 요리', rating: 4.3, description: '3대째 운영 중인 캐주얼한 분위기의 트라토리아로, 현지인에게 인기 있는 가성비 좋은 맛집입니다.' }
    ],
    '로마 판테온': [
        { name: '로토폰테', lat: 41.8988, lng: 12.4765, category: '이탈리아 요리', rating: 4.3, description: '판테온 바로 앞에 위치한 레스토랑으로, 훌륭한 전망을 제공합니다.' },
        { name: '아르만도 알 판테온 (Armando al Pantheon)', lat: 41.8997, lng: 12.4770, category: '이탈리아 요리', rating: 4.6, description: '전통적인 로마 요리를 맛볼 수 있는 유서 깊은 트라토리아로, 현지인과 관광객 모두에게 사랑받는 곳입니다.' },
        { name: '타짜 도로 (La Casa del Caffè Tazza d\'Oro)', lat: 41.9001, lng: 12.4764, category: '카페', rating: 4.7, description: '판테온 근처에 위치한 유명한 로마 커피 전문점으로, 시그니처 메뉴인 그라니따 디 카페가 유명합니다.' }
    ],
    '사그라다 파밀리아': [
        { name: '호프만', lat: 41.4030, lng: 2.1760, category: '스페인 요리', rating: 4.7, description: '바르셀로나 미슐랭 1스타 레스토랑으로, 창의적인 요리를 선보입니다.' },
        { name: '엘 글롭 가우디 (El Glop Gaudi)', lat: 41.4039, lng: 2.1729, category: '스페인 요리', rating: 4.2, description: '사그라다 파밀리아 근처에서 빠에야와 해산물 요리로 유명한 현지 맛집입니다.' },
        { name: '푸에르테시요 (Puertecillo)', lat: 41.4042, lng: 2.1740, category: '해산물 요리', rating: 4.5, description: '사그라다 파밀리아 근처에 있는 해산물 식당으로, 원하는 해산물을 직접 골라 요리해주는 것이 특징입니다.' }
    ],
    '빅벤': [
        { name: '더 폰드 마켓', lat: 51.5000, lng: -0.1250, category: '펍', rating: 4.1, description: '빅벤 근처에 있는 전통적인 영국식 펍으로, 다양한 맥주를 즐길 수 있습니다.' },
        { name: '더 시나몬 클럽 (The Cinnamon Club)', lat: 51.4998, lng: -0.1287, category: '인도 요리', rating: 4.7, description: '오래된 도서관 건물을 개조한 고급 인도 레스토랑으로, 독특한 분위기에서 현대적인 인도 요리를 즐길 수 있습니다.' },
        { name: '세인트 스테판스 태번 (St. Stephen\'s Tavern)', lat: 51.5006, lng: -0.1265, category: '펍', rating: 4.3, description: '국회의사당 바로 앞에 위치한 유서 깊은 펍으로, 전통 영국 음식과 맥주를 맛볼 수 있습니다.' }
    ],
    '엠파이어 스테이트 빌딩': [
        { name: 'STATE Grill and Bar', lat: 40.7484, lng: -73.9857, category: '미국식', rating: 4.4, description: '엠파이어 스테이트 빌딩 근처의 고급 미국식 그릴 레스토랑입니다.' },
        { name: 'Keens Steakhouse', lat: 40.7480, lng: -73.9885, category: '스테이크', rating: 4.6, description: '전통 있는 스테이크하우스로, 진한 맛의 스테이크가 인기입니다.' },
        { name: 'The NoMad Restaurant', lat: 40.7475, lng: -73.9873, category: '퓨전', rating: 4.5, description: '모던한 분위기의 퓨전 요리 전문점으로 유명합니다.' }
    ],
    '자유의 여신상': [
        { name: 'Liberty House Restaurant', lat: 40.7047, lng: -74.0153, category: '미국식', rating: 4.3, description: '자유의 여신상 뷰가 좋은 해산물 전문 레스토랑입니다.' },
        { name: 'Battery Gardens', lat: 40.7031, lng: -74.0175, category: '이탈리안', rating: 4.2, description: '배터리 파크에 위치한 이탈리안 레스토랑으로, 경치가 뛰어납니다.' },
        { name: 'Pier A Harbor House', lat: 40.7030, lng: -74.0177, category: '시푸드', rating: 4.1, description: '해안가에 위치한 캐주얼 시푸드 레스토랑입니다.' }
    ],
    '그랜드 캐니언': [
        { name: 'El Tovar Dining Room', lat: 36.0566, lng: -112.1251, category: '미국식', rating: 4.5, description: '그랜드 캐니언 국립공원 내 전통 미국식 레스토랑입니다.' },
        { name: 'Canyon Village Market Place', lat: 36.0626, lng: -112.1235, category: '패스트푸드', rating: 4.0, description: '간단한 식사와 스낵을 즐길 수 있는 편의점과 식당입니다.' },
        { name: 'Arizona Room', lat: 36.0590, lng: -112.1257, category: '스테이크', rating: 4.3, description: '스테이크와 바비큐 요리가 인기인 그랜드 캐니언 근처 레스토랑입니다.' }
    ],
    '마추픽추': [
        { name: '마추픽추 인카테라 뷔페', lat: -13.1630, lng: -72.5450, category: '페루 요리', rating: 4.5, description: '마추픽추 근처에서 페루 전통 음식을 맛볼 수 있는 뷔페식 레스토랑입니다.' },
        { name: '더 트리 하우스', lat: -13.1557, lng: -72.5255, category: '페루 요리', rating: 4.6, description: '아구아스 칼리엔테스에 위치한 고급 레스토랑으로, 신선한 현지 재료를 사용한 퓨전 요리를 제공합니다.' },
        { name: '인디오 펠리즈 (Indio Feliz)', lat: -13.1534, lng: -72.5250, category: '페루-프랑스 퓨전', rating: 4.5, description: '독특한 분위기에서 페루와 프랑스 퓨전 요리를 맛볼 수 있는 인기 레스토랑입니다.' }
    ],
    '크라이스트 더 리디머': [
        { name: '루바이얏 리오 (Rubaiyat Rio)', lat: -22.9696, lng: -43.2081, category: '스테이크, 그릴', rating: 4.7, description: '조키 클럽 브라질레이루에 위치한 미슐랭 레스토랑으로, 예수상을 바라보며 식사할 수 있습니다.' },
        { name: '플라제 카페 (Plage Café)', lat: -22.9599, lng: -43.2052, category: '카페, 브런치', rating: 4.5, description: '파르케 라지 내부에 위치한 카페로, 식민지 시대 저택의 안뜰에서 예수상 뷰를 즐기며 브런치를 할 수 있습니다.' },
        { name: '브라질리언 뷔페 레스토랑', lat: -22.9599, lng: -43.2052, category: '브라질 요리', rating: 4.2, description: '예수상 투어 패키지에 포함되는 경우가 많은 뷔페식 식당으로, 다양한 브라질 전통 요리를 맛볼 수 있습니다.' }
    ],
    '시드니 오페라 하우스': [
        { name: '벤넬롱', lat: -33.8580, lng: 151.2160, category: '호주 요리', rating: 4.9, description: '시드니 오페라 하우스 내부에 있는 고급 레스토랑입니다.' },
        { name: '오페라 바', lat: -33.8582, lng: 151.2155, category: '다양한 요리', rating: 4.2, description: '오페라 하우스 옆에 위치한 상징적인 바/레스토랑으로, 하버 브리지와 오페라 하우스 뷰를 즐길 수 있습니다.' },
        { name: '하우스 칸틴', lat: -33.8586, lng: 151.2152, category: '아시안 퓨전', rating: 4.0, description: '오페라 하우스 아래에 위치한 캐주얼한 식당으로, 다양한 아시아 길거리 음식을 맛볼 수 있습니다.' }
    ],
    '피라미드': [
        { name: '9 피라미드 라운지', lat: 29.9800, lng: 31.1350, category: '현지 음식', rating: 4.5, description: '피라미드를 가장 가까이서 볼 수 있는 루프탑 레스토랑입니다.' },
        { name: '쿠푸스 레스토랑 (Khufu\'s)', lat: 29.9760, lng: 31.1360, category: '파인 다이닝', rating: 4.8, description: '피라미드 바로 옆에 위치한 고급 레스토랑으로, 훌륭한 뷰와 함께 미식 경험을 제공합니다.' },
        { name: '펠펠라 (Felfela)', lat: 29.9860, lng: 31.1330, category: '이집트 요리', rating: 4.3, description: '오랜 전통을 자랑하는 이집트 현지 음식점으로, 캐주얼한 분위기에서 다양한 이집트 요리를 맛볼 수 있습니다.' }
    ]
};