location ~ ^(\/[\d]+\.[\d]+\.[\d]+[\.|-][\d]+)?\/(dictionaries)(\/.*)$ {
  expires 365d;
  alias M4_DS_ROOT/server/SpellChecker/$2$3;
}
