import com.sun.net.httpserver.HttpServer;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpExchange;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;

public class HelloWorld {
    public static void main(String[] args) throws IOException {
        int port = 8000; // Puerto en el que escuchará el servidor

        // Crea una instancia de HttpServer que escucha en el puerto especificado
        HttpServer server = HttpServer.create(new InetSocketAddress(port), 0);
        // HttpHandler para requests
        server.createContext("/", new HttpHandler() {
            @Override
            public void handle(HttpExchange exchange) throws IOException {
                String response = "Hello World :)";
                exchange.sendResponseHeaders(200, response.getBytes().length);
                OutputStream os = exchange.getResponseBody();
                os.write(response.getBytes());
                os.close();
            }
        });

        server.setExecutor(null); // Crea un nuevo thread por cada solicitud
        server.start(); // Inicia el servidor
        System.out.println("Server started on port " + port); //Mensaje indicando que el servidor se ha iniciado correctamente
    }
}
