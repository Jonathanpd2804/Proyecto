import '../exports.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController(); //Email
  final passwordController = TextEditingController(); //Contraseña
  final confirmPasswordController = TextEditingController(); //Contraseña confirmada
  final nameController = TextEditingController(); //Nombre
  final lastNameController = TextEditingController(); //Apellidos
  final phoneController = TextEditingController(); //Teléfono

  bool isWorker = false; //Es trabajagor
  final code = TextEditingController(); //Código

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                Image.asset(
                  'lib/images/logo2.png',
                  height: 150,
                ),

                const SizedBox(height: 50),

                Text(
                  '!Bienvenido!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 36,
                  ),
                ),

                const SizedBox(height: 25),

                //Input de nombre
                MyTextField(
                  controller: nameController,
                  hintText: 'Nombre',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //Input de Apellidos
                MyTextField(
                  controller: lastNameController,
                  hintText: 'Apellidos',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //Input de telefono
                MyTextField(
                  controller: phoneController,
                  hintText: 'Telefono',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //Input de email
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                //Input de contraseña
                MyTextField(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                //Input de confirma contraseña
                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirmar Contraseña',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                //Checkbox de si es trabajador
                CheckboxListTile(
                  title: const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text("Trabajador"),
                  ),
                  value: isWorker,
                  onChanged: (bool? value) {
                    setState(() {
                      isWorker = value!;
                    });
                  },
                ),

                //Input de código
                Visibility(
                  visible: isWorker,
                  child: MyTextField(
                    controller: code,
                    hintText: 'Código',
                    obscureText: false,
                  ),
                ),

                const SizedBox(height: 25),

                // Botón de iniciar sesión
                MyButton(
                    text: 'Sign In',
                    onTap: UserRegister(
                      emailController: emailController,
                      passwordController: passwordController,
                      confirmPasswordController: confirmPasswordController,
                      nameController: nameController,
                      lastNameController: lastNameController,
                      phoneController: phoneController,
                      code: code,
                      context: context,
                      isWorker: isWorker,
                    ).signUp),

                const SizedBox(height: 25),

                const SizedBox(height: 50),

                // Texto de Ya tiene cuenta
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¡Ya tengo cuenta! / Entrar como invitado',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.showLoginPage,
                        child: const Text(
                          'Iniciar ahora',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
