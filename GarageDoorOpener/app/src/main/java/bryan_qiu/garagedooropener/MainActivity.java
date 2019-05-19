package bryan_qiu.garagedooropener;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.view.View.OnClickListener;

import org.json.JSONObject;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;


public class MainActivity extends AppCompatActivity {

    public static final String IPAddress = "192.168.1.85";
    public static final int ServerPort = 1729;
    private static final String HMAC_SHA256 = "HmacSHA256";
    private static final String KEY = "78e9c4a69b958cadbcbe6448d2de0894fabff7edcb2814c5f81c1c7a1c1517c0 ";

    public static byte[] hexToBytes(String s) {
        byte[] data = new byte[s.length()/2];
        for (int i = 0; i < data.length; i ++) {
            data[i] = (byte) ((Character.digit(s.charAt(i*2), 16) << 4)
                    + Character.digit(s.charAt(i*2 + 1), 16));
        }
        return data;
    }

    public static String bytesToHex(byte[] bytes) {
        final char[] hexArray = "0123456789abcdef".toCharArray();
        char[] hexChars = new char[bytes.length * 2];
        for ( int j = 0; j < bytes.length; j++ ) {
            int v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v >>> 4];
            hexChars[j * 2 + 1] = hexArray[v & 0x0F];
        }
        return new String(hexChars);
    }

    public static String calculateHMAC(String data, String key)
            throws NoSuchAlgorithmException, InvalidKeyException {
        String tmp = "a2";
        SecretKeySpec secretKeySpec = new SecretKeySpec(hexToBytes(key), HMAC_SHA256);
        Mac mac = Mac.getInstance(HMAC_SHA256);
        mac.init(secretKeySpec);
        byte[] buf = mac.doFinal(data.getBytes());
        return bytesToHex(buf);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Button button = findViewById(R.id.toggle);
        button.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                // send socket data
                try {
                    JSONObject commandData = new JSONObject();
                    Long timestamp = System.currentTimeMillis()/1000;

                    commandData.put("version", 0);
                    commandData.put("timestamp", timestamp);
                    commandData.put("type", "toggle");
                    commandData.put("details","e30=");

                    JSONObject commandWrapper = new JSONObject();

                    commandWrapper.put("hmac", calculateHMAC(commandData.toString(), KEY));
                    commandWrapper.put(
                            "commandData",
                            Base64.getEncoder().encodeToString(commandData.toString().getBytes()));
                    commandWrapper.put("userId", "bryan");

                    System.out.println("Sent: " + commandWrapper);
                    new UDPClient().execute(commandWrapper);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

        });
    }

}
