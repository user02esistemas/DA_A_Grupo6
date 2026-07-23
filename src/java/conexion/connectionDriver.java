/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package conexion;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
/**
 *
 * @author dzs-1
 */
public class connectionDriver {
    private static EntityManagerFactory emf = null;
    
    static {
        try {
            // Esto imprimirá en tu consola de NetBeans para saber si pasa por aquí
            System.out.println("=== INICIANDO CONEXIÓN EN COMPILACIÓN ===");
            emf = Persistence.createEntityManagerFactory("HotelOasisPU");
            System.out.println("=== ENTITY MANAGER FACTORY CREADO CON ÉXITO ===");
        } catch (Throwable ex) {
            System.err.println("!!! ERROR CRÍTICO EN LA PERSISTENCIA !!!");
            ex.printStackTrace(); // Esto te dirá el motivo exacto (Clave errónea, puerto cerrado, etc)
        }
    }

    public static EntityManagerFactory getEmf() {
        if (emf == null) {
            // Intento de rescate si falló en el static
            try {
                emf = Persistence.createEntityManagerFactory("HotelOasisPU");
            } catch(Exception e) {
                System.err.println("Segundo intento fallido: " + e.getMessage());
            }
        }
        return emf;
    }
}
