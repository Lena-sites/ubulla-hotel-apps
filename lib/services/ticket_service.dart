import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
import 'package:file_saver/file_saver.dart';

class TicketService {
  Future<void> downloadTicket({
    required int transactionId,
    required String username,
    required String email,
    required String hotelName,
    required int guest,
    required DateTime checkInDate,
    required DateTime checkOutDate,
  }) async {
    final pdf = pw.Document();

    // Membuat QR Code dari ID transaksi langsung, jadi ga perlu diubah ke gambar dulu
    final qrImage = pw.BarcodeWidget(
      barcode: pw.Barcode.qrCode(),
      data: transactionId.toString(),
      width: 180,
      height: 180,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'UBULLA',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text('HOTEL AND RESORT'),
              pw.SizedBox(height: 20),
              pw.Text(
                'CHECK-IN TICKET',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              qrImage,
              pw.SizedBox(height: 25),
              pw.Text('Booking ID: $transactionId'),
              pw.Text('Name: $username'),
              pw.Text('Email: $email'),
              pw.Text('Hotel: $hotelName'),
              pw.Text('Guest: $guest'),
              pw.Text('Check In: ${checkInDate.toString().split(' ')[0]}'),
              pw.Text('Check Out: ${checkOutDate.toString().split(' ')[0]}'),
            ],
          );
        },
      ),
    );

    final pdfBytes = await pdf.save();

    await FileSaver.instance.saveToDownloads(
      name: 'ticket_$transactionId',
      bytes: pdfBytes,
      fileExtension: 'pdf',
      mimeType: MimeType.pdf,
    );
  }
}
