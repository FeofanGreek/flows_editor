import 'dart:convert';

import '../utils/enums_lib.dart';
import '../utils/transliterator.dart';
import 'block_node.dart';
import 'package:json_annotation/json_annotation.dart';

part 'flow_model.g.dart';

@JsonSerializable()
class FlowModel {
  String projectName;
  String get latinName => transliterateRussian(projectName);

  String projectDescription;

  ///массив блоков с нодами
  List<NodeBloc> nodes = [];

  FlowModel({required this.projectName, required this.projectDescription});

  factory FlowModel.fromJson(Map<String, dynamic> json) => _$FlowModelFromJson(json);
  Map<String, dynamic> toJson() => _$FlowModelToJson(this);

  String toPrompt() {
    return '''
    {
    "your_role": "You're a Python developer. You're an expert in the PipeCat framework and the PipeCat Flows package.",
    "project_name": $latinName,
    "project_main_description" : "$projectDescription",
    "project_setting": "This is a telephone conversation. The user's voice will be recognized as text by Whisper model. Qwen3 model, which supports tools, will be used to process FlowsFunctionSchema actions and responses, as well as the Whisper recognition results. The Coqui model will be used to generate speech from Qwen3 responses, so it is necessary to specify the use of stress and punctuation marks in the response. Define this in role_messages using the field coqui_tts_config"
    "project_language" : "Russian",
    "your_tasks": [
    "Define names and variable sets for each node's FlowResult classes",
    "Define the names of the NodeConfig, FlowsFunctionSchema, and handler functions using only Latin characters and based on the schema_description",
    "Create handlers that execute the description specified in schema_description and switch to the next nodes in the next_nodes array in accordance with the this_node_description description of the next node.",
    "Create a set of mock data that will be used in parameters and required values FlowsFunctionSchema, FlowResult classes and handlers, 3-5 examples",
    "Determine the need for use in this node and create role_messages for the role system based on the characteristics of the model Qwen3",
    "Create task_messages for the role system based on the characteristics of the model Qwen3",
    "Define a strategy for working with context in NodeConfig, possible meanings ${ContextStrategy.values.map((e) => e.name).toList()}, considering whether the topic of conversation changes",
    "Create a conversation branching code based on the example in the section code_example",
    ],
    "coqui_tts_config": {
  "stress_marking": {
    "method": "unicode_combining_acute",
    "example": "озвучи́ть, сотру́дник",
    "note": "Stress is indicated by the symbol U+0301 after the stressed vowel."
  },
  "punctuation_for_prosody": {
    "rules": "Use periods, commas, dashes, and ellipses to control pauses and intonation.",
    "short_pause": ",",
    "medium_pause": " — ",
    "question_intonation": "?",
    "statement_intonation": "."
  },
  "llm_prompt_addition": "IMPORTANT: All answers must include stressed syllables (symbols) and correct punctuation to ensure a natural sound when spoken. Avoid long sentences; break them into several phrases. Use acute accents."
},
    "project_nodes" : ${jsonEncode(nodes.map((node) => {
      "this_node_name": node.nodeData.latinName,
      "this_node_description": node.nodeData.description,
      "flow_function_schemes": node.nodeData.functions.map((functions) => {"schema_name": functions.name, "schema_description": functions.description, "next_nodes": functions.handler.nextNodeUuid.map((next) => nodes.firstWhere((n) => n.uuid == next).nodeData.latinName).toList()}).toList(),
    }).toList())},        
    "code_example": """
    # Type definitions
class Prescription(TypedDict):
    medication: str
    dosage: str


class Allergy(TypedDict):
    name: str


class Condition(TypedDict):
    name: str


class VisitReason(TypedDict):
    name: str


# Result types for each handler
class BirthdayVerificationResult(FlowResult):
    verified: bool


class PrescriptionRecordResult(FlowResult):
    count: int


class AllergyRecordResult(FlowResult):
    count: int


class ConditionRecordResult(FlowResult):
    count: int


class VisitReasonRecordResult(FlowResult):
    count: int


# Function handlers
async def verify_birthday(
    args: FlowArgs, flow_manager: FlowManager
) -> tuple[BirthdayVerificationResult, NodeConfig]:
    """Handler for birthday verification."""
    birthday = args["birthday"]
    # In a real app, this would verify against patient records
    is_valid = birthday == "1983-01-01"

    # Store verification result in flow state
    flow_manager.state["birthday_verified"] = is_valid
    flow_manager.state["birthday"] = birthday

    return BirthdayVerificationResult(verified=is_valid), create_prescriptions_node()


async def record_prescriptions(
    args: FlowArgs, flow_manager: FlowManager
) -> tuple[PrescriptionRecordResult, NodeConfig]:
    """Handler for recording prescriptions."""
    prescriptions: List[Prescription] = args["prescriptions"]

    # Store prescriptions in flow state
    flow_manager.state["prescriptions"] = prescriptions

    # In a real app, this would store in patient records
    return PrescriptionRecordResult(count=len(prescriptions)), create_allergies_node()


async def record_allergies(
    args: FlowArgs, flow_manager: FlowManager
) -> tuple[AllergyRecordResult, NodeConfig]:
    """Handler for recording allergies."""
    allergies: List[Allergy] = args["allergies"]

    # Store allergies in flow state
    flow_manager.state["allergies"] = allergies

    # In a real app, this would store in patient records
    return AllergyRecordResult(count=len(allergies)), create_conditions_node()


async def record_conditions(
    args: FlowArgs, flow_manager: FlowManager
) -> tuple[ConditionRecordResult, NodeConfig]:
    """Handler for recording medical conditions."""
    conditions: List[Condition] = args["conditions"]

    # Store conditions in flow state
    flow_manager.state["conditions"] = conditions

    # In a real app, this would store in patient records
    return ConditionRecordResult(count=len(conditions)), create_visit_reasons_node()


async def record_visit_reasons(
    args: FlowArgs, flow_manager: FlowManager
) -> tuple[VisitReasonRecordResult, NodeConfig]:
    """Handler for recording visit reasons."""
    visit_reasons: List[VisitReason] = args["visit_reasons"]

    # Store visit reasons in flow state
    flow_manager.state["visit_reasons"] = visit_reasons

    # In a real app, this would store in patient records
    return VisitReasonRecordResult(count=len(visit_reasons)), create_verification_node()


async def revise_information(args: FlowArgs, flow_manager: FlowManager) -> tuple[None, NodeConfig]:
    """Handler to restart the information-gathering process."""
    return None, create_prescriptions_node()


async def confirm_information(args: FlowArgs, flow_manager: FlowManager) -> tuple[None, NodeConfig]:
    """Handler to confirm all collected information."""
    return None, create_confirmation_node()


async def complete_intake(args: FlowArgs, flow_manager: FlowManager) -> tuple[None, NodeConfig]:
    """Handler to complete the intake process."""
    return None, create_end_node()


# Node creation functions
def create_initial_node() -> NodeConfig:
    """Create the initial node for patient identity verification."""
    verify_birthday_func = FlowsFunctionSchema(
        name="verify_birthday",
        handler=verify_birthday,
        description="Verify the user has provided their correct birthday. Once confirmed, the next step is to record the user's prescriptions.",
        properties={
            "birthday": {
                "type": "string",
                "description": "The user's birthdate (convert to YYYY-MM-DD format)",
            }
        },
        required=["birthday"],
    )

    return NodeConfig(
        name="start",
        role_messages=[
            {
                "role": "system",
                "content": "You are Jessica, an agent for Tri-County Health Services. You must ALWAYS use one of the available functions to progress the conversation. Be professional but friendly.",
            }
        ],
        task_messages=[
            {
                "role": "system",
                "content": "Start by introducing yourself to Chad Bailey, then ask for their date of birth, including the year. Once they provide their birthday, use verify_birthday to check it. If verified (1983-01-01), proceed to prescriptions.",
            }
        ],
        functions=[verify_birthday_func],
    )


def create_prescriptions_node() -> NodeConfig:
    """Create the prescriptions collection node."""
    record_prescriptions_func = FlowsFunctionSchema(
        name="record_prescriptions",
        handler=record_prescriptions,
        description="Record the user's prescriptions. Once confirmed, the next step is to collect allergy information.",
        properties={
            "prescriptions": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "medication": {
                            "type": "string",
                            "description": "The medication's name",
                        },
                        "dosage": {
                            "type": "string",
                            "description": "The prescription's dosage",
                        },
                    },
                    "required": ["medication", "dosage"],
                },
            }
        },
        required=["prescriptions"],
    )

    return NodeConfig(
        name="get_prescriptions",
        role_messages=[
            {
                "role": "system",
                "content": "You are Jessica, an agent for Tri-County Health Services. You must ALWAYS use one of the available functions to progress the conversation. Be professional but friendly.",
            }
        ],
        task_messages=[
            {
                "role": "system",
                "content": "This step is for collecting prescriptions. Ask them what prescriptions they're taking, including the dosage. Get to the point by saying 'Thanks for confirming that. First up, what prescriptions are you currently taking, including the dosage for each medication?'. After recording prescriptions (or confirming none), proceed to allergies.",
            }
        ],
        context_strategy=ContextStrategyConfig(strategy=ContextStrategy.RESET),
        functions=[record_prescriptions_func],
    )


def create_allergies_node() -> NodeConfig:
    """Create the allergies collection node."""
    record_allergies_func = FlowsFunctionSchema(
        name="record_allergies",
        handler=record_allergies,
        description="Record the user's allergies. Once confirmed, then next step is to collect medical conditions.",
        properties={
            "allergies": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "name": {
                            "type": "string",
                            "description": "What the user is allergic to",
                        },
                    },
                    "required": ["name"],
                },
            }
        },
        required=["allergies"],
    )

    return NodeConfig(
        name="get_allergies",
        task_messages=[
            {
                "role": "system",
                "content": "Collect allergy information. Ask about any allergies they have. After recording allergies (or confirming none), proceed to medical conditions.",
            }
        ],
        functions=[record_allergies_func],
    )


def create_conditions_node() -> NodeConfig:
    """Create the medical conditions collection node."""
    record_conditions_func = FlowsFunctionSchema(
        name="record_conditions",
        handler=record_conditions,
        description="Record the user's medical conditions. Once confirmed, the next step is to collect visit reasons.",
        properties={
            "conditions": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "name": {
                            "type": "string",
                            "description": "The user's medical condition",
                        },
                    },
                    "required": ["name"],
                },
            }
        },
        required=["conditions"],
    )

    return NodeConfig(
        name="get_conditions",
        task_messages=[
            {
                "role": "system",
                "content": "Collect medical condition information. Ask about any medical conditions they have. After recording conditions (or confirming none), proceed to visit reasons.",
            }
        ],
        functions=[record_conditions_func],
    )


def create_visit_reasons_node() -> NodeConfig:
    """Create the visit reasons collection node."""
    record_visit_reasons_func = FlowsFunctionSchema(
        name="record_visit_reasons",
        handler=record_visit_reasons,
        description="Record the reasons for their visit. Once confirmed, the next step is to verify all information.",
        properties={
            "visit_reasons": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "name": {
                            "type": "string",
                            "description": "The user's reason for visiting",
                        },
                    },
                    "required": ["name"],
                },
            }
        },
        required=["visit_reasons"],
    )

    return NodeConfig(
        name="get_visit_reasons",
        task_messages=[
            {
                "role": "system",
                "content": "Collect information about the reason for their visit. Ask what brings them to the doctor today. After recording their reasons, proceed to verification.",
            }
        ],
        functions=[record_visit_reasons_func],
    )


def create_verification_node() -> NodeConfig:
    """Create the information verification node with context reset and summary."""
    revise_information_func = FlowsFunctionSchema(
        name="revise_information",
        handler=revise_information,
        description="Return to prescriptions to revise information",
        properties={},
        required=[],
    )

    confirm_information_func = FlowsFunctionSchema(
        name="confirm_information",
        handler=confirm_information,
        description="Proceed with confirmed information",
        properties={},
        required=[],
    )

    return NodeConfig(
        name="verify",
        task_messages=[
            {
                "role": "system",
                "content": """Review all collected information with the patient. Follow these steps:
1. Summarize their prescriptions, allergies, conditions, and visit reasons
2. Ask if everything is correct
3. Use the appropriate function based on their response

Be thorough in reviewing all details and wait for explicit confirmation.""",
            }
        ],
        context_strategy=ContextStrategyConfig(
            strategy=ContextStrategy.RESET_WITH_SUMMARY,
            summary_prompt=(
                "Summarize the patient intake conversation, including their birthday, "
                "prescriptions, allergies, medical conditions, and reasons for visiting. "
                "Focus on the specific medical information provided."
            ),
        ),
        functions=[revise_information_func, confirm_information_func],
    )


def create_confirmation_node() -> NodeConfig:
    """Create the final confirmation node."""
    complete_intake_func = FlowsFunctionSchema(
        name="complete_intake",
        handler=complete_intake,
        description="Complete the intake process",
        properties={},
        required=[],
    )

    return NodeConfig(
        name="confirm",
        task_messages=[
            {
                "role": "system",
                "content": "Once confirmed, thank them, then use the complete_intake function to end the conversation.",
            }
        ],
        functions=[complete_intake_func],
    )


def create_end_node() -> NodeConfig:
    """Create the final end node."""
    return NodeConfig(
        name="end",
        task_messages=[
            {
                "role": "system",
                "content": "Thank them for their time and end the conversation.",
            }
        ],
        post_actions=[{"type": "end_conversation"}],
    )
    """
    }
    ''';
  }

  String toPython() {
    return '''
#перечисляем в коде импорты
from loguru import logger
from pipecat_flows import (
    FlowArgs,
    FlowManager,
    FlowsFunctionSchema,
    NodeConfig,
)

#section with FlowResult classes
${nodes.map((node) {
      return '''${node.nodeData.functions.map((schema) {
        return '''
class ${schema.handler.flowResultName}Result(FlowResult):
    ${schema.handler.properties.entries.map((prop) => '${prop.key}: ${prop.value["type"]}').toList().join('\n')}
    ${schema.handler.addonProperties.map((addon) => '${addon.name}: ${addon.type.python}').toList().join('\n')}
''';
      }).toList().join('')}
''';
    }).toList().join('')}  
#section with Actions (pre and post)
${nodes.map((node) {
      return '''
${node.nodeData.preActions.map((pre) {
        return '''
async def ${pre.handlerName} (action: dict, flow_manager: FlowManager) -> None:
    """Check if kitchen is open and log status."""
    logger.info("Checking kitchen status") 
''';
      }).toList().join('')}     
      
${node.nodeData.postActions.map((post) {
        return '''
async def ${post.handlerName} (action: dict, flow_manager: FlowManager) -> None:
    """Check if kitchen is open and log status."""
    logger.info("Checking kitchen status") 
''';
      }).toList().join('')}       
''';
    }).toList().join('')}
#section with handlers
${nodes.map((node) {
      return '''${node.nodeData.functions.map((schema) {
        return '''
async def ${schema.handler.latinName}(args: FlowArgs, flow_manager: FlowManager) -> tuple[None, NodeConfig]:
    """Разобрать входные параметры, нод резалт классы и определитель выходного нода"""
    ${schema.handler.properties.entries.map((prop) => '${prop.key} = args["${prop.key}"]').toList().join('\n')}
    ${schema.handler.addonProperties.map((addon) => '${addon.name} = args["${addon.name}"]').toList().join('\n')}
    result = ДОБАВИТЬ МАТЕМАТИКУ
    
    flowResult = ${schema.handler.flowResultName}Result(ДОБАВИТЬ ОПРЕДЕЛИТЕЛЬПАРАМЕТРОВ)
    
    nextNode = ФУНКЦИЯ ПО РЕЗУЛЬТАТМ ОБРАБОТКИ
    
    return flowResult, nextNode
''';
      }).toList().join('')}
''';
    }).toList().join('')}        
#sections with FlowsFunctionSchema
${nodes.map((node) {
      return '''${node.nodeData.functions.map((schema) {
        return '''
${schema.name} = FlowsFunctionSchema(
        name="${schema.handler.latinName}",
        handler=${schema.handler.latinName},
        description="${schema.description}",
        properties=${jsonEncode(schema.handler.properties)},
        required=${jsonEncode(schema.handler.required)},
    )
''';
      }).toList().join('')}  
''';
    }).toList().join('')}

#section with NodeConfig
${nodes.map((node) {
      return '''def ${node.nodeData.latinName.replaceAll(' ', '_')}_node() -> NodeConfig:
    """${node.nodeData.description}"""
    return NodeConfig(
        name="${node.nodeData.latinName.replaceAll(' ', '_')}",
        pre_actions=${node.nodeData.preActions.map((pre) => pre.type == ActionTypes.tts_say
          ? {"type": "tts_say", "text": pre.text ?? ''}
          : pre.type == ActionTypes.end_conversation
          ? {"type": "end_conversation", "text": pre.text ?? ''}
          : '{"type": "function", "handler": ${pre.handlerName!.replaceAll(' ', '_')}}').toList()},
        role_messages=${jsonEncode(node.nodeData.roleMessage ?? [])},
        task_messages=${jsonEncode(node.nodeData.taskMessage)},
        functions=${node.nodeData.functions.map((func) => func.name).toList()},
        context_strategy=ContextStrategyConfig(strategy=ContextStrategy.${node.nodeData.context_strategy.name}),
        post_actions=${node.nodeData.postActions.map((post) => post.type == ActionTypes.tts_say
          ? {"type": "tts_say", "text": post.text ?? ''}
          : post.type == ActionTypes.end_conversation
          ? {"type": "end_conversation", "text": post.text ?? ''}
          : '{"type": "function", "handler": ${post.handlerName!.replaceAll(' ', '_')}}').toList()},
        respond_immediately=${node.nodeData.respondImmediately ? 'True' : 'False'}
    )  
''';
    }).toList().join('')}   
''';
  }
}
