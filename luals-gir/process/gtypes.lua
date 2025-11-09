-- Table of basic GLib types and a few GObject types mapped to Lua types
-- See: https://docs.gtk.org/glib/types.html
return {
  none = "nil",
  gboolean = "boolean",

  ["gchar*"] = "string",
  ["guchar*"] = "string",
  utf8 = "string",

  gint = "integer",
  gint8 = "integer",
  gint16 = "integer",
  gint32 = "integer",
  gint64 = "integer",
  guint = "integer",
  guint8 = "integer",
  guint16 = "integer",
  guint32 = "integer",
  guint64 = "integer",

  gshort = "integer",
  gushort = "integer",
  glong = "integer",
  gulong = "integer",

  gsize = "integer",
  gssize = "integer",
  goffset = "integer",

  gfloat = "number",
  gdouble = "number",

  -- TODO: I'm not sure how to represent these
  gpointer = "any",
  gintptr = "any",
  guintptr = "any",

  ["GObject.Callback"] = "function",
}
