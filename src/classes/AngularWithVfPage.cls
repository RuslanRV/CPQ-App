public with sharing class AngularWithVfPage {

    public static String getContacts() {
       return JSON.serialize([select Id, Name, Email from contact]);
    }
}