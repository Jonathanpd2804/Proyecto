import '../exports.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _esTrabajador = false;
  final _codigoTrabajador = TextEditingController();

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

                // logo
                Image.asset(
                  'lib/images/logo2.png',
                  height: 150,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  '!Bienvenido!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 36,
                  ),
                ),

                const SizedBox(height: 25),

                //nombre textfield
                MyTextField(
                  controller: _nameController,
                  hintText: 'Nombre',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // apellidos textfield
                MyTextField(
                  controller: _lastNameController,
                  hintText: 'Apellidos',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // telefono textfield
                MyTextField(
                  controller: _phoneController,
                  hintText: 'Telefono',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // email textfield
                MyTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: _passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // confirmar contraseña textfield
                MyTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirmar Contraseña',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                CheckboxListTile(
                  title: const Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: Text("Trabajador"),
                  ),
                  value: _esTrabajador,
                  onChanged: (bool? value) {
                    setState(() {
                      _esTrabajador = value!;
                    });
                  },
                ),
                Visibility(
                  visible: _esTrabajador,
                  child: MyTextField(
                    controller: _codigoTrabajador,
                    hintText: 'Código',
                    obscureText: false,
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                    text: 'Sign In',
                    onTap: UserRegister(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      nameController: _nameController,
                      lastNameController: _lastNameController,
                      phoneController: _phoneController,
                      codigoTrabajador: _codigoTrabajador,
                      context: context,
                      esTrabajador: _esTrabajador,
                    ).signUp),

                const SizedBox(height: 25),

                const SizedBox(height: 50),

                // not a member? register now
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
