# Generated by Django 5.1.6 on 2025-03-02 05:15

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('tastebuds', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='customuser',
            name='last_login',
            field=models.DateTimeField(blank=True, null=True, verbose_name='last login'),
        ),
        migrations.AlterField(
            model_name='customuser',
            name='password',
            field=models.CharField(max_length=128, verbose_name='password'),
        ),
    ]
