%dw 2.0
import * from dw::Crypto
import * from dw::core::Strings

fun validateStripeSignature(rawBody: String, signatureHeader: String, secret: String): Boolean = do {
    var parts = signatureHeader splitBy ","
    var timestamp = (parts filter ($ startsWith "t="))[0] replace "t=" with ""
    var v1 = (parts filter ($ startsWith "v1="))[0] replace "v1=" with ""
    var signedPayload = timestamp ++ "." ++ rawBody
    var expectedSig = HMACWith(signedPayload as Binary {encoding: "UTF-8"}, secret as Binary {encoding: "UTF-8"}, "HmacSHA256") as String {base: 16}
    ---
    expectedSig == v1
}