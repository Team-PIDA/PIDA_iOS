public enum Region: String, Equatable, Sendable {
  case seoul = "SEOUL"
  case gyeonggi = "GYEONGGI"
  case busan = "BUSAN"
  case daegu = "DAEGU"
  case incheon = "INCHEON"
  case gwangju = "GWANGJU"
  case daejeon = "DAEJEON"
  case ulsan = "ULSAN"
  case sejong = "SEJONG"
  case gangwon = "GANGWON"
  case chungbuk = "CHUNGBUK"
  case chungnam = "CHUNGNAM"
  case jeonbuk = "JEONBUK"
  case jeonnam = "JEONNAM"
  case gyeongbuk = "GYEONGBUK"
  case gyeongnam = "GYEONGNAM"
  case jeju = "JEJU"

  public init?(administrativeArea: String) {
    if administrativeArea.contains("서울")           { self = .seoul }
    else if administrativeArea.contains("경기")      { self = .gyeonggi }
    else if administrativeArea.contains("부산")      { self = .busan }
    else if administrativeArea.contains("대구")      { self = .daegu }
    else if administrativeArea.contains("인천")      { self = .incheon }
    else if administrativeArea.contains("광주")      { self = .gwangju }
    else if administrativeArea.contains("대전")      { self = .daejeon }
    else if administrativeArea.contains("울산")      { self = .ulsan }
    else if administrativeArea.contains("세종")      { self = .sejong }
    else if administrativeArea.contains("강원")      { self = .gangwon }
    else if administrativeArea.contains("충청북")    { self = .chungbuk }
    else if administrativeArea.contains("충청남")    { self = .chungnam }
    else if administrativeArea.contains("전라북") || administrativeArea.contains("전북") { self = .jeonbuk }
    else if administrativeArea.contains("전라남")    { self = .jeonnam }
    else if administrativeArea.contains("경상북")    { self = .gyeongbuk }
    else if administrativeArea.contains("경상남")    { self = .gyeongnam }
    else if administrativeArea.contains("제주")      { self = .jeju }
    else { return nil }
  }

  public var name: String {
    switch self {
    case .seoul:    return "서울"
    case .gyeonggi: return "경기"
    case .busan:    return "부산"
    case .daegu:    return "대구"
    case .incheon:  return "인천"
    case .gwangju:  return "광주"
    case .daejeon:  return "대전"
    case .ulsan:    return "울산"
    case .sejong:   return "세종"
    case .gangwon:  return "강원"
    case .chungbuk: return "충북"
    case .chungnam: return "충남"
    case .jeonbuk:  return "전북"
    case .jeonnam:  return "전남"
    case .gyeongbuk: return "경북"
    case .gyeongnam: return "경남"
    case .jeju:     return "제주"
    }
  }
}
