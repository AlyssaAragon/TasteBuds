# Generated by Django 5.1.2 on 2024-11-12 23:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('tastebuds', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='allrecipe',
            name='description',
            field=models.TextField(blank=True, null=True),
        ),
    ]
