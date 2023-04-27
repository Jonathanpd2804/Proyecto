export 'package:flutter/material.dart';
export 'package:flutter/services.dart';

export '/main.dart';

//Pages
export 'package:david_perez/pages/login_page.dart';
export 'package:david_perez/pages/register_page.dart';
export 'package:david_perez/pages/forgot_pw_page.dart';
export 'package:david_perez/pages/home_page.dart';
export 'package:david_perez/pages/workers_page.dart';
export 'package:david_perez/pages/bookings_page.dart';
export 'package:david_perez/pages/products_page.dart';
export 'package:david_perez/pages/manage_page.dart';
export 'package:david_perez/pages/jobs_page.dart';
export 'package:david_perez/pages/facilities_page.dart';
export 'package:david_perez/pages/maintenance_page.dart';
export 'package:david_perez/pages/services_page.dart';

//Calendars
export 'package:david_perez/pages/calendars/calendar_worker_page.dart';
export 'package:david_perez/pages/calendars/calendar_quotes_page.dart';
export 'package:david_perez/pages/calendars/calendar_ask_quote.dart';

//Services
export 'package:david_perez/pages/calendars/services/calendar_service.dart';

//Profile
export 'package:david_perez/pages/profile/profile_page.dart';
export 'package:david_perez/pages/profile/manage/delete_user.dart';
export 'package:david_perez/pages/profile/manage/edit_user.dart';

//Firebase
export 'package:firebase_core/firebase_core.dart';
export 'package:firebase_auth/firebase_auth.dart';
export 'firebase_options.dart';
export 'package:cloud_firestore/cloud_firestore.dart';
export 'package:image_picker/image_picker.dart';
export 'package:firebase_storage/firebase_storage.dart';
export 'package:firebase_database/firebase_database.dart'
    hide Query, Transaction, TransactionHandler;

//Google
export 'package:google_sign_in/google_sign_in.dart';

//Email
export 'package:mailer/mailer.dart';
export 'package:mailer/smtp_server.dart';

//Widgets
export 'package:david_perez/widgets/my_button.dart';
export 'package:david_perez/widgets/my_textfield.dart';
export 'package:david_perez/widgets/square_tile.dart';
export 'package:david_perez/widgets/custom_appbar.dart';
export 'package:david_perez/widgets/custom_drawer.dart';
export 'package:david_perez/widgets/icons.dart';
export 'package:david_perez/widgets/icons_home.dart';

//List
export 'package:david_perez/widgets/lists/task_list_view.dart';
export 'package:david_perez/widgets/lists/quotes_list_view.dart';

//Products
export 'package:david_perez/widgets/products/products_colum.dart';
export 'package:david_perez/widgets/products/product_card_widget.dart';
export 'package:david_perez/widgets/products/add_product.dart';

//Jobs
export 'package:david_perez/widgets/jobs/add_job.dart';
export 'package:david_perez/widgets/jobs/job_card_widget.dart';
export 'package:david_perez/widgets/jobs/jobs_row.dart';
export 'package:david_perez/widgets/jobs/edit_job.dart';

//Tasks
export 'package:david_perez/widgets/task/create_task.dart';
export 'package:david_perez/widgets/task/create_task_page.dart';
export 'package:david_perez/widgets/task/edit_task.dart';
export 'package:david_perez/widgets/task/show_task.dart';
export 'package:david_perez/widgets/task/delete_task.dart';

//Quotes
export 'package:david_perez/widgets/quotes/show_quote.dart';
export 'package:david_perez/widgets/quotes/delete_quote.dart';

//Pub dev
export 'package:auto_size_text/auto_size_text.dart';
export 'package:table_calendar/table_calendar.dart';
export 'package:flip_card/flip_card.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:url_launcher/url_launcher.dart';
export 'package:flutter_rating_bar/flutter_rating_bar.dart';

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
export 'package:david_perez/read_data/get_user_is_admin.dart';
export 'package:david_perez/read_data/get_user_is_worker.dart';
export 'package:david_perez/read_data/get_user_document_id.dart';
