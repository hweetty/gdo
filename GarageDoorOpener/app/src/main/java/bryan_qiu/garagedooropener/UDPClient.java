package bryan_qiu.garagedooropener;

import java.net.DatagramPacket;
import java.net.DatagramSocket;
import java.net.InetAddress;
import android.os.AsyncTask;

import org.json.JSONObject;

public class UDPClient extends AsyncTask<JSONObject, Void, Void> {

    @Override
    protected void onPreExecute() {
        super.onPreExecute();
    }

    @Override
    protected Void doInBackground(JSONObject... params)
    {
        JSONObject json = params[0];
        DatagramSocket ds = null;
        try
        {
            ds = new DatagramSocket();
            InetAddress sendAddress = InetAddress.getByName(MainActivity.IPAddress);
            DatagramPacket dp;
            byte[] buf = new byte[2024];
            buf = json.toString().getBytes();
            dp = new DatagramPacket(buf, buf.length, sendAddress, MainActivity.ServerPort);
            ds.send(dp);
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    protected void onPostExecute(Void result) {
        super.onPostExecute(result);
    }
}