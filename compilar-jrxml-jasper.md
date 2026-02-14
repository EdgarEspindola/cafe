# Establecer Java 8 temporalmente
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

# Verificar versión
java -version
# Debe mostrar: openjdk version "1.8.0_242"

# Compilar el reporte
cd ruta-proyecto/cafe

# Crear el compilador Java
cat > /tmp/JasperCompiler.java << 'EOF'
import net.sf.jasperreports.engine.JasperCompileManager;
public class JasperCompiler {
    public static void main(String[] args) throws Exception {
        for (String file : args) {
            System.out.println("Compilando: " + file);
            JasperCompileManager.compileReportToFile(
                file, 
                file.replace(".jrxml", ".jasper")
            );
            System.out.println("✓ Generado: " + file.replace(".jrxml", ".jasper"));
        }
    }
}
EOF

# Compilar el helper
javac -cp "lib/jasper-bridge/jasper-reports/lib/*:lib/jasper-bridge/jasper-reports/*.jar" \
      /tmp/JasperCompiler.java

# Compilar tus reportes
java -cp "lib/jasper-bridge/jasper-reports/lib/*:lib/jasper-bridge/jasper-reports/*.jar:/tmp" \
     JasperCompiler reports/entradas.jrxml reports/salidas_bodega.jrxml