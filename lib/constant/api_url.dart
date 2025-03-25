  // ignore_for_file: non_constant_identifier_names, constant_identifier_names

  // https://192.168.100.202:8443/building-management/api/staff/
  // https://posdemo.sisapp.com:8443/building-management/api/staff/

  const String MAIN_BASE = "https://satsat.up.railway.app/api/";
  const String SECONDARY_BASE = "https://satsat.up.railway.app/api/";

  enum ApiUrl {
    SIGN_IN("login"),
    SIGN_UP("register"),
    ACCOUNT("users"),
    BYPASS("bypass"),
    IMEI("imei");

    final String path;

    const ApiUrl(this.path);
  }
