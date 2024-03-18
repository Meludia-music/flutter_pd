package com.meludia.FlutterPDTest.exception

import java.lang.Exception

class PdException(val code: String,
                  message: String?,
                  val detail: Any? = null) : Exception(message)
