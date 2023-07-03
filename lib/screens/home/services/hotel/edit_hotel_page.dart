import 'package:flutter/material.dart';
import 'package:touriso_agent/models/hotels/hotel.dart';
import 'package:touriso_agent/screens/home/services/hotel/rooms_grid.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/screens/shared/custom_text_form_field.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';

class EditHotelPage extends StatefulWidget {
  const EditHotelPage({super.key, this.hotel});
  final Hotel? hotel;

  @override
  State<EditHotelPage> createState() => _EditHotelPageState();
}

class _EditHotelPageState extends State<EditHotelPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController sloganController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      showBackButton: true,
      title: 'Edit hotel details',
      actions: const [
        IconTextButton(icon: Icons.delete, color: Colors.red),
      ],
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(48),
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: nameController,
                    hintText: 'Name',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextFormField(
                    controller: phoneController,
                    hintText: 'Phone', //TODO: prepopulate
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextFormField(
                    controller: phoneController,
                    hintText: 'Email', //TODO: prepopulate
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: CustomTextFormField(
                    controller: descriptionController,
                    hintText: 'Description',
                    // maxLines: 10,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomTextFormField(
                    controller: sloganController,
                    hintText: 'Slogan',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Text('Rooms', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
              ],
            ),
            RoomsGrid(),
          ],
        ),
      ),
    );
  }
}
