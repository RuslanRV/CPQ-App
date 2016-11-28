<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_it_pls</fullName>
        <description>Email it pls</description>
        <protected>false</protected>
        <recipients>
            <recipient>r.vekuade@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/aaaaaa</template>
    </alerts>
    <alerts>
        <fullName>Email_it_pls_2</fullName>
        <description>Email it pls 2</description>
        <protected>false</protected>
        <recipients>
            <recipient>r.vekuade@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/aaaaaa</template>
    </alerts>
    <alerts>
        <fullName>Not_approved</fullName>
        <ccEmails>ruslan.vekua@amindsolutions.com</ccEmails>
        <description>Not approved</description>
        <protected>false</protected>
        <recipients>
            <recipient>david.valko@amindsolutions.com11</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>r.vekuade@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Disccount_Approval_Needed</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status_to_Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Approval Status to Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_approval_status</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Update approval status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Message_Discount</fullName>
        <apiVersion>38.0</apiVersion>
        <endpointUrl>https://www.google.ge</endpointUrl>
        <fields>AccountId</fields>
        <fields>Amount</fields>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>r.vekuade@gmail.com</integrationUser>
        <name>Message Discount</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Oppty Rule 1</fullName>
        <actions>
            <name>Email_it_pls</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.OrderNumber__c</field>
            <operation>equals</operation>
            <value>1111</value>
        </criteriaItems>
        <description>Oppty Rule 1</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_it_pls_2</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Opportunity.My_Test_Date__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
