from django import forms

class PartnerLinkForm(forms.Form):
    partner_email = forms.EmailField(label="Partner Email", max_length=100)



