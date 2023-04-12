export 'package:flutter/material.dart';
export 'package:flutter/services.dart';

export '/main.dart';

//Pages
export 'package:david_perez/pages/login_page.dart';
export 'package:david_perez/pages/register_page.dart';
export 'package:david_perez/pages/forgot_pw_page.dart';
export 'package:david_perez/pages/home_page.dart';
export 'package:david_perez/pages/trabajadores_page.dart';
export 'package:david_perez/pages/calendarios/calendario_trabajador_page.dart';
export 'package:david_perez/pages/calendarios/calendario_cliente_page.dart';
export 'package:david_perez/pages/calendarios/calendario_citas_page.dart';
export 'package:david_perez/pages/calendarios/calendario_tarde.dart';
export 'package:david_perez/pages/calendarios/calendario_manana.dart';
export 'package:david_perez/pages/perfil_page.dart';
export 'package:david_perez/pages/medidores_page.dart';

//Tasks
export 'package:david_perez/task/create_task.dart';
export 'package:david_perez/task/create_task_page.dart';
export 'package:david_perez/task/edit_task.dart';
export 'package:david_perez/task/show_task.dart';

//Citas
export 'package:david_perez/citas/create_cita.dart';
export 'package:david_perez/citas/create_cita_page.dart';


//Firebase
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'firebase_options.dart';
export 'package:cloud_firestore/cloud_firestore.dart';

//Widgets
export 'package:david_perez/widgets/my_button.dart';
export 'package:david_perez/widgets/my_textfield.dart';
export 'package:david_perez/widgets/square_tile.dart';
export 'package:david_perez/widgets/custom_appbar.dart';
export 'package:david_perez/widgets/custom_drawer.dart';
export 'package:david_perez/widgets/card_image_widget.dart';
export 'package:david_perez/widgets/listas/task_list_view.dart';
export 'package:david_perez/widgets/listas/citas_list_view.dart';

//Pub dev
export 'package:auto_size_text/auto_size_text.dart';
export 'package:table_calendar/table_calendar.dart';
export 'package:flip_card/flip_card.dart';
export 'package:flutter_svg/flutter_svg.dart';


//Auth
export 'package:david_perez/auth/google_auth.dart';
export 'package:david_perez/auth/auth_page.dart';

//Services
export 'package:david_perez/services/user_auth.dart';
export 'package:david_perez/services/user_register.dart';

//Read Data
export 'package:david_perez/read_data/get_user_apellidos.dart';
export 'package:david_perez/read_data/get_user_email.dart';
export 'package:david_perez/read_data/get_user_name.dart';
export 'package:david_perez/read_data/get_user_telefono.dart';
export 'package:david_perez/read_data/get_user_horario.dart';
export 'package:david_perez/read_data/get_user_is_boss.dart';
export 'package:david_perez/read_data/get_user_is_worker.dart';